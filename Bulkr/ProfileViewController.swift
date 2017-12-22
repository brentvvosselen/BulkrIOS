import UIKit

class ProfileViewController: UIViewController{
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyProjects(completion: {(response) -> Void in
            self.setPosts(response)
            self.postsCollectionView.dataSource = self
            self.postsCollectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postsCollectionView.refreshControl = refreshControl
        
        
    }
    
    func setPosts(_ posts: [Post]){
        self.posts = posts
        
    }
    
    @objc func refresh(refreshControl: UIRefreshControl){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostService.getMyProjects(completion: {(response) -> Void in
            self.setPosts(response)
            self.postsCollectionView.reloadData()
            refreshControl.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostCell", for: indexPath) as! PostCell
        cell.post = posts[indexPath.item]
        return cell
    }
}

/*extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - CGFloat(8))
        return CGSize(width: cellWidth, height: 150)
    }
}*/
