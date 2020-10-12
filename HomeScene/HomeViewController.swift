
import MapKit
import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    var locationManager: CLLocationManager!
    
    var locations = [Location]()
    
    var currentUserLocation: Location!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
//MARK: - Declare Delegates
        
        let recentLocations = LocationManager.shared.getLocations()
        
        locations = [recentLocations[0], recentLocations[1]]
        
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
//MARK: - Search button UI alterations
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowColor = UIColor.white.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        searchButton.layer.shadowRadius = 1.0
     
    }
}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let firstLocation = locations.first!
        currentUserLocation = Location(title: "Current Location", address: "", latitude: 37.787359, longitude: -122.408227)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error retrieving user's location: \(error.localizedDescription)")
        return
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.updateCell(with: location)
        return cell
    }
    
    
}
extension HomeViewController: MKMapViewDelegate {
    
    
    
}
