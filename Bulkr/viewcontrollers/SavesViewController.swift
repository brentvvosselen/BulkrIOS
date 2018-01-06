import UIKit
import MaterialComponents.MaterialSnackbar

class SavesViewController: UIViewController {
    
    @IBOutlet weak var savedPostsTableView: UITableView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMySaves(completion: {(response) -> Void in
            self.posts = response
            self.savedPostsTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }, failure: {(message) -> Void in
            let sMessage = MDCSnackbarMessage()
            sMessage.text = message
            MDCSnackbarManager.show(sMessage)
        })
    }
    
    
}

extension SavesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savesPostCell", for: indexPath) as! PostTableCell
        cell.post = posts[indexPath.row]
        return cell
    }
}
