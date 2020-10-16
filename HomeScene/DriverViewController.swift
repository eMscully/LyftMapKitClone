
import UIKit
import MapKit

class DriverViewController: UIViewController {
    
    var pickupLocation: Location!
    var dropOffLocation: Location!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ETAlabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var driverPic: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locations = LocationManager.shared.getLocations()
        pickupLocation = locations[0]
        dropOffLocation = locations[1]
        let (driver, eta) =  DriverManager.shared.getETA(pickUpLocation: pickupLocation)
        
        
        //MARK: - Customize UI elements
        driverPic.layer.cornerRadius = driverPic.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderWidth = 1.0
        licenseLabel.layer.borderColor = UIColor(named: "CitrusGreen")?.cgColor
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        
        
        
        //MARK: - Set Driver class properties
        ETAlabel.text = "ARRIVES IN \(eta) MIN"
        driverNameLabel.text = driver.name
        carModelLabel.text = driver.carModel
        let rateAsString = String(format: "%.1f", driver.rating)
        ratingLabel.text = rateAsString
        ratingImage.image = UIImage(named: K.Thumbnails.rating)
        carImage.image = UIImage(named: K.Thumbnails.hyundai)
        driverPic.image = UIImage(named: K.Thumbnails.driver)
        licenseLabel.text = driver.licenseNumber
        
        
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
        let dropOffCoordinate = CLLocationCoordinate2D(latitude: dropOffLocation.latitude, longitude: dropOffLocation.longitude)
        
        let driverAnnotation = CarAnnotation(coordinate: driver.coordinate)
        let pickupAnnotation = RouteAnnotation(coord: pickupCoordinate, locationType: "pickup")
        let dropOffAnnotation = RouteAnnotation(coord: dropOffCoordinate, locationType: "dropOff")
        
        //Create a reusable constant for the multiple annotations; explicitly declare the map annotation type because Swift will infer that the map annotations array is an array of NSObjects. The .addAnnotations and .showAnnotations delegate methods require an array of MKAnnotations, NOT NSObjects
        let mapAnnotations: [MKAnnotation] = [driverAnnotation, pickupAnnotation, dropOffAnnotation]
        mapView.addAnnotations(mapAnnotations)
        mapView.showAnnotations(mapAnnotations, animated: false)
       
        
        let driverLocation = Location(title: driver.name, address: driver.licenseNumber, latitude: driver.coordinate.latitude, longitude: driver.coordinate.longitude)
       
//Route starting coordinate is the driver's current location and the route end point is where the user currently is to be picked up
        displayRoute(start: driverLocation, end: pickupLocation)
    }
}

extension DriverViewController: MKMapViewDelegate {
    //MARK: - Set up annotation views
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
    
        let reuseIdentifier = annotation is CarAnnotation ? "CarAnnotation" : "RouteAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
 
        if annotation is CarAnnotation {
            annotationView?.image = UIImage(named: K.Thumbnails.carAnnotation)
        }
        else if let routeAnnotation = annotation as? RouteAnnotation {
            annotationView!.image = UIImage(named: "\(routeAnnotation.locationType)")
        }
        
        return annotationView
    }
//MARK: - Set up Route view
        
func displayRoute(start: Location, end: Location){
    
        let startCoordinate = CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude)
        let endCoordinate = CLLocationCoordinate2D(latitude: end.latitude, longitude: end.longitude)
    
            let startPlacemark = MKPlacemark(coordinate: startCoordinate)
            let endPlacemark = MKPlacemark(coordinate: endCoordinate)
    
            let directionsRequest = MKDirections.Request()
            directionsRequest.source = MKMapItem(placemark: startPlacemark)
            directionsRequest.destination = MKMapItem(placemark: endPlacemark)
            directionsRequest.transportType = .automobile
    
            let directions = MKDirections(request: directionsRequest)
            directions.calculate { (response, error) in
                if let error = error {
                    print("Error calculating route directions: \(error)")
                    return
                }
                guard let response = response else {
                    return
                }
    
                let route = response.routes.first!
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
               
            }
       }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5.0
            renderer.strokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            return renderer
        }
    
}



