
import Foundation
import CoreLocation

class LyftRideQuoteManager {
    static let shared = LyftRideQuoteManager()
    
    private init() {
        
        
        /**
         The getRideQuotes function calculates price quotes based on the distance selected by user; price also fluctuates based on the type of vehicle selected.
         
         Declaration (auto-generated by Swift)
         
         *Values*
          
           `locationStart` A new CLLocation parameter object initialized with Core Location coordinate data
          
          
           `locationEnd` A new CLLocation parameter object initialized with Core Location coordinate data
          
           
           `distance` This function uses the CLLocation distance method when generating a ride quote calculation.
         
           
           `surcharge` A hardcoded value that Lyft service requires all riders pay regardless of distance travelled
         
            
           `price calculation` Computation multiplies the metric distance by the Lyft company standard charges for the vehicle type selected, and  then adds the surchage.
         
         Parameters:
         
         - parameter first: The user's current location or requested pick up location
         - parameter second: The user's destination location 
         - returns: Returns an array of 3 quote calculations for user to choose from
         - throws: Error handling Description
         
         
         Declared in (auto-generated by Swift for easier navigation to source file)
         
         
         */
        func getRideQuotes(pickUpLocation: Location, dropOffLocation: Location)-> [LyftRideQuote] {
            
            let locationStart = CLLocation(latitude: pickUpLocation.latitude, longitude: pickUpLocation.longitude)
            let locationEnd = CLLocation(latitude: dropOffLocation.latitude, longitude: dropOffLocation.longitude)
            
            let distance = locationStart.distance(from: locationEnd)
            
            let surcharge = 3.0
            
            return [LyftRideQuote(img: K.Thumbnails.shared, car: K.RideName.shared, price: surcharge + (distance * 0.005), arrivalTime: Date(), capacity: K.Passengers.sharedCapacity),
                    LyftRideQuote(img: K.Thumbnails.compact, car: K.RideName.compact, price: surcharge + (distance * 0.009), arrivalTime: Date(), capacity: K.Passengers.compactCapacity),
                    LyftRideQuote(img: K.Thumbnails.large, car: K.RideName.large, price: surcharge + (distance * 0.015), arrivalTime: Date(), capacity: K.Passengers.largeCapacity)]
        }
        
        
    }
    
    
    
}