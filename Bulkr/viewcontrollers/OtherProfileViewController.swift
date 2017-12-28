import UIKit

class OtherProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        
        //get user data
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UserService.getUserInfo(for: (user?.email)!, completion: {(response) -> Void in
            self.user = response
            self.userPosts = response.posts!
            
            self.followersLabel.text = String(describing: response.followers!) + " Followers"
            
            if let picture = response.picture {
                let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                let pictureDecoded = UIImage(data: dataDecoded)
                self.profileImageView.image = pictureDecoded
            }else{
                self.profileImageView.image = #imageLiteral(resourceName: "noPicture")
            }
            self.postsTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    var userPosts: [Post] = []
    var user: User?{
        didSet{
            self.title = user?.email!
           /* if let followers = user?.followers {
                self.followersLabel.text = String(describing: followers) + " Followers"
            }
            
            if let posts = user?.posts{
                userPosts = posts
                postsTableView.reloadData()
            }
            
            if let picture = user?.picture {
                let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                let pictureDecoded = UIImage(data: dataDecoded)
                self.profileImageView.image = pictureDecoded
            } else {
                self.profileImageView.image = #imageLiteral(resourceName: "noPicture")
            }*/
            
        }
    }
    
    
}

extension OtherProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherProfilePostCell", for: indexPath) as! PostTableCell
        cell.post = userPosts[indexPath.row]
        return cell
    }
}
