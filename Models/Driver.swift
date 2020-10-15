
import Foundation

class Driver {

    let name: String

    //Driver picture property is a String type that will be assigned to the name of the picture in assets.xcassets folder
    let driverPic: String
    let licenseNumber: String

    //Rating is a float type based on the values 1.0 - 5.0 "stars"
    let rating: Float

    let carModel: String

 
    init(name: String, driverPic: String, licenseNumber: String, rating: Float, carModel: String) {
    	self.name = name
    	self.driverPic = driverPic
    	self.licenseNumber = licenseNumber
    	self.rating = rating
    	self.carModel = carModel

}
