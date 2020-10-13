
import MapKit
import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    private var locationManager: CLLocationManager?
    
    var locations = [Location]()
    
    var currentUserLocation: Location?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
//MARK: - Core Location Manager Configuration and Delegation:
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()

  
        locationManager?.startUpdatingLocation()

//MARK: - Delegatation continued:
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        
        // Seeding data : temporary placemarker
        let recentLocations = LocationManager.shared.getLocations()
        locations = [recentLocations[0], recentLocations[1]]
        
        
//MARK: - Search button CALayer alterations
        searchButton
            .layer
            .cornerRadius = 10.0
        searchButton
            .layer
            .shadowColor = UIColor.white.cgColor
        searchButton
            .layer
            .shadowOffset = CGSize(width: 0.5, height: 0.5)
        searchButton
            .layer
            .shadowRadius = 1.0
    }
}
//MARK: - Core Location Manager Delegate Methods:

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus  {
        case .restricted, .denied:
            locationManager?.stopUpdatingLocation()
            print("Authorization denied or restricted")
            break
            
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            locationManager?.allowsBackgroundLocationUpdates = false
            
            
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.pausesLocationUpdatesAutomatically = false
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
       
        case .notDetermined:
            locationManager?.stopUpdatingLocation()
            print("Authorization undetermined")
            break
            
        default:
            print("Error")
            break
            
        }
        
        if manager.accuracyAuthorization == CLAccuracyAuthorization.reducedAccuracy {
            locationManager?.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation") {
                error in
                if manager.accuracyAuthorization == .fullAccuracy {
                    print("Full Location Accuracy Temporarily Granted")
                } else {
                    print("Approximate, reduced accuracy only. User has denied full location accuracy.")
                }
            }
            locationManager?.startUpdatingLocation()
                
        }
        
    

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if locations.first != nil {
            let location = locations.first!
              currentUserLocation = Location(title: "Current Location", address: "", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    
    }
    
//MARK: - Graceful fail CLLocationManager delegate method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error retrieving user's location: \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
        
    }
    
}
//MARK: - Table View Delegate and Data Source Methods
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
//MARK: - Map View Delegate Methods
extension HomeViewController: MKMapViewDelegate {
    
    
    
}
