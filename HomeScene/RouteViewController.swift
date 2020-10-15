import UIKit
import MapKit

class RouteViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startLocationLabel: UILabel!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    @IBOutlet weak var selectRideButton: UIButton!
    
    var rideQuote: [LyftRideQuote]!
    var startLocation: Location?
    var destination: Location?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        selectRideButton.layer.cornerRadius = 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        startLocationLabel.text = startLocation?.title
        destinationLocationLabel.text = destination?.title
    }
    



}
extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.rideCell) as! RideQuoteCell
        let quote = rideQuote[indexPath.row]
        cell.updateCell(with: quote)
        return cell
    }
    
    
    
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
