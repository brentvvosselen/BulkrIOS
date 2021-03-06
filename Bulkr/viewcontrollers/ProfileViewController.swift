import UIKit
import MaterialComponents.MaterialSnackbar

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        
        //round picture
        pictureImageView.layer.cornerRadius = 35
        pictureImageView.layer.masksToBounds = true
        
        //get user data
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            UserService.getUserInfo(for: user, completion: {(response) -> Void in
                self.setPosts(response.posts!)
                self.emailLabel.text = response.email
                self.followersLabel.text = String(describing: response.followers!) + " Followers"
                //picture
                if let picture = response.picture {
                    let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                    let pictureDecoded = UIImage(data: dataDecoded)
                    self.pictureImageView.image = pictureDecoded
                } else {
                    self.pictureImageView.image = #imageLiteral(resourceName: "noPicture")
                }
                self.postsTableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
        }
        
        
        //set up refresh control
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
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            UserService.getUserInfo(for: user, completion: {(response) -> Void in
                self.setPosts(response.posts!)
                self.emailLabel.text = response.email
                self.followersLabel.text = String(describing: response.followers!) + " Followers"
                //picture
                if let picture = response.picture {
                    let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                    let pictureDecoded = UIImage(data: dataDecoded)
                    self.pictureImageView.image = pictureDecoded
                } else {
                    self.pictureImageView.image = #imageLiteral(resourceName: "noPicture")
                }
                self.postsTableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                refreshControl.endRefreshing()
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
                refreshControl.endRefreshing()
            })
        }
        
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

