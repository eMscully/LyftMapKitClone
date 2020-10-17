
import UIKit
import MapKit

class DropOffLocationViewController: UIViewController {

    @IBOutlet weak var dropOffTextField: UITextField!
    @IBOutlet weak var pickUpTextField: UITextField!
    

    @IBOutlet weak var tableView: UITableView!
    
    private var searchCompleter: MKLocalSearchCompleter?
    var searchResults = [MKLocalSearchCompletion]()
    var locations = [Location]()
    var pickUpLocation: Location!
    var dropOffLocation: Location!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
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

    //add code here for pop view controller when user presses cancel in the nav bar 

    
}

extension DropOffLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let latestString = (dropOffTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
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

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RouteViewController, let dropOffLocation = sender as? Location {
            if segue.identifier == "routeSegue" {
                destinationViewController.pickUpLocation = pickUpLocation
                destinationViewController.dropOffLocation = dropOffLocation
            }
        }
    }
}

extension DropOffLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//ternary operator expression for table view to show query search results in the table view (if any), OR to show the user's recent locations in the table view instead
        return searchResults.isEmpty ? locations.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.locationCell) as! LocationCell
       
        if searchResults.isEmpty {
            let location = locations[indexPath.row]
            cell.updateCell(with: location)
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.updateCell(with: searchResult)
            
        }
        
        return cell
    }

   

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.isEmpty{
            let location = locations[indexPath.row]
            performSegue(withIdentifier: "routeSegue", sender: location)
        } else {
            // Convert searchResult -> Location object
            let searchResult = searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: searchResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start(completionHandler: { (response, error) in
                if error == nil{
                    if let dropoffPlacemark = response?.mapItems.first?.placemark{
                        let location = Location(placemark: dropoffPlacemark)
                        self.performSegue(withIdentifier: "routeSegue", sender: location)
                    }
                }
            })

}
}
}

