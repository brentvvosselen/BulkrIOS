import UIKit
import MaterialComponents.MaterialSnackbar

class FeedViewController: UIViewController {
    @IBOutlet weak var postTableView: UITableView!
    
    var posts: [Post] = []
    var page = 0
    var hasmoreposts = true

    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        print("hello")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyFeed(at: page, completion: {(response) -> Void in
            self.addPosts(response)
            if response.count < 5 {
                self.hasmoreposts = false
            }
            self.postTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }, failure: {(message) -> Void in
            let sMessage = MDCSnackbarMessage()
            sMessage.text = message
            MDCSnackbarManager.show(sMessage)
        })
        
        //set up refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postTableView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.page = 0
        PostService.getMyFeed(at: page, completion: {(response) -> Void in
            self.posts = response
            if response.count < 5 {
                self.hasmoreposts = false
            }else{
                self.hasmoreposts = true
            }
            self.postTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            refreshControl.endRefreshing()
        }, failure: {(message) -> Void in
            let sMessage = MDCSnackbarMessage()
            sMessage.text = message
            MDCSnackbarManager.show(sMessage)
            refreshControl.endRefreshing()
        })
    }
    
    @IBAction func unwindFromAddPost(_ segue: UIStoryboardSegue){
        switch segue.identifier {
        case "didAddPost"?:
            let addPostViewController = segue.source as! AddPostViewController
            posts.append(addPostViewController.post!)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            PostService.addPost(addPostViewController.post!, completion: {(response) -> Void in
                print(response)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.postTableView.reloadData()
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = "We could not add your post"
                MDCSnackbarManager.show(sMessage)
            })
        default:
            fatalError("Unknown segue")
        }
    }
    
    func addPosts(_ posts: [Post]){
        self.posts.append(contentsOf: posts)
    }
}

extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableCell",for: indexPath) as! PostTableCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
   
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count {
            if hasmoreposts {
                print("new posts")
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                page += 1
                PostService.getMyFeed(at: page, completion: {(response) -> Void in
                    self.addPosts(response)
                    if response.count < 5 {
                        self.hasmoreposts = false
                    }
                    self.postTableView.reloadData()
                    
                    print(self.posts)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }, failure: {(message) -> Void in
                    let sMessage = MDCSnackbarMessage()
                    sMessage.text = message
                    MDCSnackbarManager.show(sMessage)
                })
            }
            
        }
    }
}

