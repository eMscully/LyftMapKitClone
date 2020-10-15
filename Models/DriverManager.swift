
import Foundation
import UIKit

class DriverManager {
    static let shared = DriverManager()
    
    init(){}
    
    
    func getDriverProfile(driver: Driver) {
        driver.name = "Alicia Castillo"
        driver.carType = K.Thumbnails.hyundai
        driver.rating = UIImage(named: K.Thumbnails.rating)
        driver.profilePic = UIImage(named: K.Thumbnails.driver)
    }
    
    
}
