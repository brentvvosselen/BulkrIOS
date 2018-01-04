import UIKit

class OtherProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var followButton: UIButton!
    
    var follows: Bool = false{
        didSet{
            switch follows{
            case true:
                self.followButton.setTitle("unfollow", for: .normal)
            case false:
                self.followButton.setTitle("follow", for: .normal)
            }
        }
    }
    @IBAction func followClick(_ sender: Any) {
        switch follows{
        case true:
            UserService.unfollow(usermail: (user?.email)!, completion: {(response) -> Void in
                self.follows = false
            })
        case false:
            UserService.follow(usermail: (user?.email)!, completion: {(response) -> Void in
                self.follows = true
            })
        }
    }
    
    override func viewDidLoad() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        
        followButton.backgroundColor = .clear
        followButton.layer.cornerRadius = 3
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = UIColor(red: 205/255, green: 72/255, blue: 61/255, alpha: 1).cgColor
        followButton.contentEdgeInsets = UIEdgeInsetsMake(10,15,10,15)
        
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
        
        UserService.doesFollow(usermail: (user?.email)!, completion: {(response) -> Void in
            self.follows = response
            print(response)
        })
    }
    
    var userPosts: [Post] = []
    var user: User?{
        didSet{
            self.title = user?.email!
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
