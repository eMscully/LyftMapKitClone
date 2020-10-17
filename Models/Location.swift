
import Foundation
import MapKit

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

	
init(placemark: MKPlacemark){
	self.title = placemark.name ?? ""
	self.address = placemark.title ?? ""
	self.latitude = placemark.coordinate.latitude
	self.longitude = placemark.coordinate.longitude

	}
	
}

