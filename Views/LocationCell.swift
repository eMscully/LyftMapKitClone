
import Foundation
import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    func updateCell(with location: Location){
        titleLabel.text = location.title
        addressLabel.text = location.address
    }
}
