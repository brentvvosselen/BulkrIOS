import UIKit

class SearchUserCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: User!{
        didSet{
            emailLabel.text = user.email
            if let followers = user.followers {
                followersLabel.text = String(describing: followers) + " Followers"
            }
            
            //round picture
            userImageView.layer.cornerRadius = 30
            userImageView.layer.masksToBounds = true
            
            //set picture
            if let picture = user.picture{
                let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                let pictureDecoded = UIImage(data: dataDecoded)
                userImageView.image = pictureDecoded
            }else{
                userImageView.image = #imageLiteral(resourceName: "noPicture")
            }
            
        }
    }
}

