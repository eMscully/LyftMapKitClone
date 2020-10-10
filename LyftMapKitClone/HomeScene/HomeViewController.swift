//
//  ViewController.swift
//  LyftMapKitClone
//
//  Created by Erin Scully on 10/9/20.
//
import MapKit
import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    var recentLocations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//MARK: - Declare Delegates
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        
        locationManager?.requestWhenInUseAuthorization()
        
    }


}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("User coordinates = Lat: \(latitude), Lng: \(longitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error retrieving user's location: \(error.localizedDescription)")
        return
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
        
        // return recentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        
        return cell
    }
    
    
}
extension HomeViewController: MKMapViewDelegate {
    
    
    
}
