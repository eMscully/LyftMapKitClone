
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
        
        mapView.addAnnotations([driverAnnotation, pickupAnnotation, dropOffAnnotation])
        
    }
}

extension DriverViewController: MKMapViewDelegate {
    
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
}

extension DriverViewController {
    
}
