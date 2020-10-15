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
    
   
    var lyftRideQuotes = [LyftRideQuote]()
    var startLocation: Location?
    var destination: Location?
    var selectedIndex = 1
    
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
        
//        //Temporarily populating properties for data seeding:
//        let locations = LocationManager.shared.getLocations()
//        startLocation = locations[0]
//        destination = locations[1]
        

//        startLocationLabel.text = startLocation?.title
//        destinationLocationLabel.text = destination?.title
        lyftRideQuotes = LyftRideQuoteManager.shared.getRideQuotes(pickUpLocation: startLocation!, dropOffLocation: destination!)
          

        

    }
    



}
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

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func displayRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D){
        let startPlacemark = MKPlacemark(coordinate: start)
        let endPlacemark = MKPlacemark(coordinate: end)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: startPlacemark)
        directionsRequest.destination = MKMapItem(placemark: endPlacemark)
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            if let error = error {
                print("Error calculating route directions: \(error.localizedDescription)")
                return
            }
          if let response = response {
            let route = response.routes.first!
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0), animated: true)
        }
    }
}
}
