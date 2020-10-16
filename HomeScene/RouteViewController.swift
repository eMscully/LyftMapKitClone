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
    var startLocation: Location!
    var destination: Location!
        
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
        
        
        
        
        //Temporarily populating properties for data seeding:
//        let locations = LocationManager.shared.getLocations()
//        startLocation = locations[0]
//        destination = locations[1]


        
        startLocationLabel.text = startLocation.title
        destinationLocationLabel.text = destination.title
        
        
        lyftRideQuotes = LyftRideQuoteManager.shared.getRideQuotes(pickUpLocation: startLocation, dropOffLocation: destination)
          
 //MARK: - Create route start and end point annotations
        let pickUpCoord = CLLocationCoordinate2D(latitude: startLocation!.latitude, longitude: startLocation!.longitude)
        let dropOffCoord = CLLocationCoordinate2D(latitude: destination!.latitude, longitude: destination!.longitude)
        
        let pickUpAnnotation = RouteAnnotation(coord: pickUpCoord, locationType: "pickUp")
        let dropOffAnnotation = RouteAnnotation(coord: dropOffCoord, locationType: "dropOff")
        mapView.addAnnotations([pickUpAnnotation, dropOffAnnotation])

    displayRoute(start: startLocation, end: destination)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let goToDriverVC = segue.destination as? DriverViewController {
            if segue.identifier == K.Identifier.goToDriverSegue {
                goToDriverVC.pickupLocation = startLocation
                goToDriverVC.dropOffLocation = destination
            }
        }
    }
    
    @IBAction func selectRidePressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Identifier.goToDriverSegue, sender: self)
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
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return renderer
    }
}

