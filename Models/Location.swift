
import Foundation

class Location: Codable {
	var title: String
	var address: String
	let latitude: Double
	let longitude: Double

	init(title: String, address: String, latitude: Double, longitude: Double){
		self.title = title
		self.address = address
		self.latitude = latitude
		self.longitude = longitude
	}
}

