
import UIKit
import MapKit

class DriverViewController: UIViewController {

    var pickupLocation: Location!
    var dropOffLocation: Location!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ETAlabel: UILabel!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var carModelLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBOutlet weak var carImage: UIImageView!
    
    
    @IBOutlet weak var driverPic: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        driverPic.layer.cornerRadius = driverPic.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderWidth = 1.0
        licenseLabel.layer.borderColor = UIColor(named: "CitrusGreen")?.cgColor
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        
        let locations = LocationManager.shared.getLocations()
        pickupLocation = locations[0]
        dropOffLocation = locations[1]
        
       let (driver, eta) =  DriverManager.shared.getETA(pickUpLocation: pickupLocation)
  
        ETAlabel.text = "ARRIVES IN \(eta) MIN"
        driverNameLabel.text = driver.name
        carModelLabel.text = driver.carModel
        let rateAsString = String(format: "%.1f", driver.rating)
        ratingLabel.text = rateAsString
        
        ratingImage.image = UIImage(named: K.Thumbnails.rating)
        carImage.image = UIImage(named: K.Thumbnails.hyundai)
        driverPic.image = UIImage(named: K.Thumbnails.driver)
        licenseLabel.text = driver.licenseNumber
    }
    


}
