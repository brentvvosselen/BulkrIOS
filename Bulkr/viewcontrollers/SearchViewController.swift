import UIKit
import MaterialComponents.MaterialSnackbar

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foundUsersTable: UITableView!
    
    var foundUsers: [User] = []
    private var selectedIndex: Int?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showProfile"?:
            let otherProfileViewController = segue.destination as! OtherProfileViewController
            otherProfileViewController.user = foundUsers[foundUsersTable.indexPathForSelectedRow!.row]
        default:
            fatalError("Unknown segue")
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UserService.findUsers(searchString: searchText, completion: {(response) -> Void in
            self.foundUsers = response
            self.foundUsersTable.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }, failure: {(message) -> Void in
            let sMessage = MDCSnackbarMessage()
            sMessage.text = message
            MDCSnackbarManager.show(sMessage)
        })
    }
}

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath) as! SearchUserCell
        cell.user = foundUsers[indexPath.row]
        return cell
        
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        print(indexPath)
    }
}
