import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var postTableView: UITableView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        print("hello")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyFeed(at: 0, completion: {(response) -> Void in
            self.addPosts(response)
            /*self.postCollectionView.dataSource = self
            self.postCollectionView.delegate = self*/
            self.postTableView.reloadData()
            
            print(self.posts)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                //self.postCollectionView.dataSource = self
                self.postTableView.reloadData()
                
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

