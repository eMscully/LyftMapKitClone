
import Foundation

class Location: Codable {
    var title: String
    var address: String
    let lat: Double
    let lng: Double
    
    init(title: String, address: String, lat: Double, lng: Double){
        self.title = title
        self.address = address
        self.lat = lat
        self.lng = lng
    }
}
