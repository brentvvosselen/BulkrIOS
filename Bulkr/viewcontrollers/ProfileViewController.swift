import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyProjects(completion: {(response) -> Void in
            self.setPosts(response)
            self.postsTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postsTableView.refreshControl = refreshControl
        
        
    }
    
    func setPosts(_ posts: [Post]){
        self.posts = posts
        
    }
    
    @objc func refresh(refreshControl: UIRefreshControl){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyProjects(completion: {(response) -> Void in
            self.setPosts(response)
            self.postsTableView.reloadData()
            refreshControl.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilePostCell", for: indexPath) as! PostTableCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

