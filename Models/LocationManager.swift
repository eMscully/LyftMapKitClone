
import Foundation

class LocationManager {
    static let shared = LocationManager()
    
    private var locations = [Location]()
    
    private init() {
        if let locationsJSON = Bundle.main.url(forResource: "locations-JSON", withExtension: "json"){
            do {
                let data = try Data(contentsOf: locationsJSON)
                let decoder = JSONDecoder()
                locations = try decoder.decode([Location].self, from: data)
            }
            catch {
                print("Error decoding JSON location data: \(error.localizedDescription)")
            }
        }
        
    }
    
    
}
