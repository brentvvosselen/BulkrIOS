import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    var posts: [Post] = []
    
    @IBAction func unwindFromAddPost(_ segue: UIStoryboardSegue){
        switch segue.identifier {
        case "didAddPost"?:
            let addPostViewController = segue.source as! AddPostViewController
            posts.append(addPostViewController.post!)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            PostService.addPost(addPostViewController.post!, completion: {(response) -> Void in
                    print(response)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
        default:
            fatalError("Unknown segue")
        }
    }
}
