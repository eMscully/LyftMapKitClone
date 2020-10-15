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
        
        //Temporarily populating properties for data seeding:
        let locations = LocationManager.shared.getLocations()
        startLocation = locations[0]
        destination = locations[1]
        

        startLocationLabel.text = startLocation?.title
        destinationLocationLabel.text = destination?.title
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
        return cell
    }
    
    
    
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
