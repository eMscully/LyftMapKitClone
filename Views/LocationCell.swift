
import Foundation
import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    //MARK: - Update table cell view with user's recent locations
    func updateCell(with location: Location){
        titleLabel.text = location.title
        addressLabel.text = location.address
    }
//MARK: - Update table cell view to show autocompletion location search results (otherwise table cells will show a list view of all the user's recent locations)
    func updateCell(with searchResult: MKLocalSearchCompletion){
        titleLabel.text = searchResult.title
        addressLabel.text = searchResult.subtitle
    }
}
