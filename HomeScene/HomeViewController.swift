
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
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//MARK: - Core Location Manager Configuration and Delegation:
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locations = LocationManager.shared.getLocations()

//MARK: - Delegatation continued:
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
   
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
    //MARK: - Passing user's current location information to the drop off view controller screen
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? DropOffLocationViewController {
            if segue.identifier == K.Identifier.homeToLocationsSegue {
                destinationViewController.pickUpLocation = currentUserLocation
            }
        }
    }
//            } else if let routeDestinationViewControlloer = segue.destination as? RouteViewController, let dropoffLocation = sender as? Location {
//                if segue.identifier == K.Identifier.dropOffSceneToRouteScene {
//                routeDestinationViewControlloer.startLocation = currentUserLocation
//                routeDestinationViewControlloer.destination = dropoffLocation
//            }
//        }
//   }
//    }
    
        
    @IBAction func searchPressed(_ sender: UIButton) {
       
        

//        performSegue(withIdentifier: K.Identifier.dropOffSceneSegue, sender: self)
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
    
//MARK: - "Graceful fail" CLLocationManager delegate method
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.locationCell) as! LocationCell
        let location = locations[indexPath.row]
        cell.updateCell(with: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let dropOffLocation = locations[indexPath.row]
        //performSegue(withIdentifier: K.Identifier.dropOffSceneToRouteScene, sender: dropOffLocation)
        
    }
    
}
//MARK: - Map View Delegate Methods
extension HomeViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Zoom in on region
        let distance = 200.0
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        
        mapView.setRegion(region, animated: true)
        
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let annotationViewOffset = 0.00075
        let c1 = CLLocationCoordinate2D(latitude: latitude - annotationViewOffset, longitude: longitude - annotationViewOffset)
        let c2 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude + annotationViewOffset)
        let c3 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude - annotationViewOffset)
        
        mapView.addAnnotations([CarAnnotation(coordinate: c1), CarAnnotation(coordinate: c2), CarAnnotation(coordinate: c3)])
        
        
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil  }
       
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CarAnnotation")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CarAnnotation")
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: K.Thumbnails.carAnnotation)
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(360) * 180) / CGFloat.pi)
        return annotationView
    }

    
    
}
