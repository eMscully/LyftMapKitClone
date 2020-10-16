
import Foundation
import UIKit
import CoreLocation

class DriverManager {
    static let shared = DriverManager()
    
    private init(){}
    
    
// Create a method that takes in 'current location' coordinate and outputs the lyft driver's ETA from the user's location. 


    func getETA(pickUpLocation: Location) -> (Driver, Int) {
        
        let locations = LocationManager.shared.getLocations()
        let randomLocation = locations[Int(arc4random_uniform(UInt32(locations.count)))]
        let coordinate = CLLocationCoordinate2D(latitude: randomLocation.latitude, longitude: randomLocation.longitude)
        let driver = Driver(name: "Alicia Castillo", driverPic: K.Thumbnails.driver, licenseNumber: "7WSB312", rating: 5.0, carModel: K.Thumbnails.hyundai, coord: coordinate)
       
        return (driver, 10)
        
     


	}

    
}
