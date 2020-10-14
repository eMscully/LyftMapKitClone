
import UIKit
import MapKit

class DropOffLocationViewController: UIViewController {

    @IBOutlet weak var dropOffTextField: UITextField!
  
    @IBOutlet weak var tableView: UITableView!
    
    private var searchCompleter: MKLocalSearchCompleter?
    var searchResults = [MKLocalSearchCompletion]()
    var locations = [Location]()
    var pickUpLocation: Location?
    var dropOffLocation: Location?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dropOffTextField.delegate = self
        dropOffTextField.becomeFirstResponder()
        
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
       
        locations = LocationManager.shared.getLocations()
     
    }
    

    @IBAction func dropOffTextFieldPressed(_ sender: UITextField) {
    }

    
}

extension DropOffLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.updateCell(with: location)
        return cell
    }
    
    
}

extension DropOffLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let latestString = (dropOffTextField.text as! NSString).replacingCharacters(in: range, with: string)
        
        if latestString.count > 3 {
            searchCompleter?.queryFragment = latestString
        }
        return true
}
}
extension DropOffLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}
