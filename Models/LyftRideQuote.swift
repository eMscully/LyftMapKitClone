
import Foundation

class LyftRideQuote {
    //Image is a string because UIImageView uses a string name identifier for the image icon
    let rideThumbnailImage: String
   // Ride types = Shared, Compact, or Large
    let rideType: String
    let ridePrice: Double
    let arrivalTime: Date
    //Passenger capacity is a STRING, not an Int because the passenger number is rendered in a UILabel TEXT label
    let passengerCapacity: String
    
    
    init(img: String, car: String, price: Double, arrivalTime: Date, capacity: String) {
        rideThumbnailImage = img
        rideType = car
        ridePrice = price
        self.arrivalTime = arrivalTime
        passengerCapacity = capacity
    }
    
    
}
