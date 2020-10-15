
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
        priceLabel.text = String(rideQuote.ridePrice)
        rideTypeLabel.text = rideQuote.rideType
        
        let dateAsTime = DateFormatter()
      
        dateAsTime.dateFormat = "hh:mma"
        timeLabel.text = dateAsTime.string(from: rideQuote.arrivalTime)
    }
    }
        

    

