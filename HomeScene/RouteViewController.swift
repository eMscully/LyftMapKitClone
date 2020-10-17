import UIKit
import MapKit

class RouteViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    @IBOutlet weak var selectRideButton: UIButton!
    
//MARK: - Class properties:
    
    var lyftRideQuotes = [LyftRideQuote]()
    var pickUpLocation: Location!
    var dropOffLocation: Location!
        
    //this property is used to keep track of what cell the user selects because the selected cell's appearance will change
    var selectedIndex = 1
    
//MARK: - Lifecycle methods:
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        
        routeLabelContainer.layer.cornerRadius = 10.0
        selectRideButton.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self

        startLocationLabel.text = pickUpLocation?.title
        destinationLocationLabel.text = dropOffLocation?.title


        
        
        
      //  Temporarily populating properties for data seeding:
//        let locations = LocationManager.shared.getLocations()
//        pickUpLocation = locations[0]
//        dropOffLocation = locations[1]


        

        
        
        lyftRideQuotes = LyftRideQuoteManager.shared.getRideQuotes(pickUpLocation: pickUpLocation!, dropOffLocation: dropOffLocation!)
          
 //MARK: - Create route start and end point annotations
        let pickUpCoord = CLLocationCoordinate2D(latitude: pickUpLocation!.latitude, longitude: pickUpLocation!.longitude)
        let dropOffCoord = CLLocationCoordinate2D(latitude: dropOffLocation!.latitude, longitude: dropOffLocation!.longitude)
        
        let pickUpAnnotation = RouteAnnotation(coord: pickUpCoord, locationType: "pickUp")
        let dropOffAnnotation = RouteAnnotation(coord: dropOffCoord, locationType: "dropOff")
        mapView.addAnnotations([pickUpAnnotation, dropOffAnnotation])

    displayRoute(sourceLocation: pickUpLocation, endLocation: dropOffLocation)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

    
    // teacher doesn't have a perform segue call here like you do......
    @IBAction func selectRidePressed(_ sender: UIButton) {
      //  performSegue(withIdentifier: K.Identifier.goToDriverSegue, sender: self)
    }
    

}
//MARK: - UITableView delegate methods

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyftRideQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.rideCell) as! RideQuoteCell
        let rideQuote = lyftRideQuotes[indexPath.row]
        cell.updateCell(with: rideQuote)
        cell.updateSelectedStatus(status: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedRideQuote = lyftRideQuotes[indexPath.row]
        selectRideButton.setTitle("Select \(selectedRideQuote.rideType)", for: .normal)
        tableView.reloadData()
        }
}
//MARK: - Map View Delegate methods:

extension RouteViewController: MKMapViewDelegate {

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reuseIdentifier = "RouteAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
    
    if annotationView == nil {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
    } else {
        annotationView?.annotation = annotation
       
        }
    let routeAnnotation = annotation as! RouteAnnotation
    annotationView!.image = UIImage(named: "\(routeAnnotation.locationType)")
    return annotationView
    }
    
    
func displayRoute(sourceLocation: Location!, endLocation: Location!){
    
    let startCoordinate = CLLocationCoordinate2D(latitude: sourceLocation.latitude, longitude: sourceLocation.longitude)
    let endCoordinate = CLLocationCoordinate2D(latitude: endLocation.latitude, longitude: endLocation.longitude)
    
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
          if let response = response {

            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return renderer
    }
    
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let goToDriverVC = segue.destination as? DriverViewController {
            if segue.identifier == "goToDriver" {
                goToDriverVC.pickUpLocation = pickUpLocation
                goToDriverVC.dropOffLocation = dropOffLocation
            }
        }
    }
}

}
