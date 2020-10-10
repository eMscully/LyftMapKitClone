
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
//MARK: - Method created so other classes can access the decoded JSON locations array  (required due to locations data being a private LocationManager class variable)
    func getLocations()->[Location]{
        return locations
    }
}
