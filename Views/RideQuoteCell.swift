
import Foundation
import UIKit

class RideQuoteCell: UITableViewCell {
    @IBOutlet weak var rideThumbnail: UIImageView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rideTypeLabel: UILabel!
    
    
    
    func updateCell(with rideQuote: LyftRideQuote){
        rideThumbnail.image = UIImage(named: rideQuote.rideThumbnailImage)
        capacityLabel.text = rideQuote.passengerCapacity
        
        
        
        let priceAsString = String(format: "%.2f", rideQuote.ridePrice)
        priceLabel.text = "$\(priceAsString)"
        rideTypeLabel.text = rideQuote.rideType
        
        let dateAsTime = DateFormatter()
      
        dateAsTime.dateFormat = "hh:mma"
        timeLabel.text = dateAsTime.string(from: rideQuote.arrivalTime)
    }
    
   //The updateSelectedStatus method evaluates whether cell selected is true or false and then changes the UI accordingly to signal/differentiate to user which cell they've selected
    
    func updateSelectedStatus(status: Bool) {
        //if status is true, give the table cell a colored border
        if status {
            contentView.layer.cornerRadius = 5.0
            contentView.layer.borderColor = UIColor(named: "CitrusGreen")?.cgColor
            contentView.layer.borderWidth = 2.0
        }
//if not,the table cell should remain as the default view
        else {
            contentView.layer.borderWidth = 0.0
        }
    
    
    }
    
    }
        

    

