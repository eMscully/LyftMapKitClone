
import Foundation

class LyftRideQuoteManager {
    static let shared = LyftRideQuoteManager()
    
    private init() {
        
        func getRideQuotes(pickUpLocation: Location, dropOffLocation: Location)-> [LyftRideQuote] {
            return [LyftRideQuote(img: K.Thumbnails.shared, car: K.RideName.shared, price: 3.05, arrivalTime: Date(), capacity: K.Passengers.sharedCapacity),
                    LyftRideQuote(img: K.Thumbnails.compact, car: K.RideName.compact, price: 3.08, arrivalTime: Date(), capacity: K.Passengers.compactCapacity),
                    LyftRideQuote(img: K.Thumbnails.large, car: K.RideName.large, price: 3.14, arrivalTime: Date(), capacity: K.Passengers.largeCapacity)]
        }
        
        
    }
    
    
    
}
