import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foundUsersTable: UITableView!
    
    var foundUsers: [User] = []
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UserService.findUsers(searchString: searchText, completion: {(response) -> Void in
            self.foundUsers = response
            self.foundUsersTable.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
