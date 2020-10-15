
import MapKit
import UIKit


class RouteAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
  
    //property is named location type to help differentiate between the annotation for the starting point and annotation for the ending point of the Route drawing
    let locationType: String
    
    init(coord: CLLocationCoordinate2D, locationType: String){
        coordinate = coord
        self.locationType = locationType
    }
}
