import UIKit

class PostTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var posterPicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bulkButton: UIButton!
    
    var saved: Bool = false
    var liked: Bool = false
    
    var currentUser: String = "brent.vanvosselen@live.be"
    
    var post: Post!{
        didSet{
            titleLabel.text = post.title
            posterLabel.text = post.poster?.email
            descriptionLabel.text = post.description
            
            
            //profile picture of poster
            if let picture = post.poster?.picture{
                let dataDecoded: Data = Data(base64Encoded: picture.value!, options: .ignoreUnknownCharacters)!
                let pictureDecoded = UIImage(data: dataDecoded)
                posterPicture.image = pictureDecoded
            }else{
                posterPicture.image = #imageLiteral(resourceName: "noPicture")
            }
            
            //picture from post
            if let postPicture = post.picture{
                let dataDecoded: Data = Data(base64Encoded: postPicture.value!, options: .ignoreUnknownCharacters)!
                let pictureDecoded = UIImage(data: dataDecoded)
                postImage.image = pictureDecoded
            }
            
            //round picture
            posterPicture.layer.cornerRadius = 25
            posterPicture.layer.masksToBounds = true
            
            //check if liked
            for user in post.likes! {
                if user.email == currentUser {
                    liked = true
                    bulkButton.setTitle("UNBULK", for: .normal)
                }
            }
            
            //check if saved
            for user in post.saves! {
                if user.email == currentUser {
                    saved = true
                    saveButton.setTitle("SAVED", for: .normal)
                }
            }
        }
    }
    @IBAction func bulk(_ sender: Any) {
        print("bulk")
        if !liked {
            //like
            PostService.likePost(post.id!, completion: {(response) -> Void in
                self.liked = true
                self.bulkButton.setTitle("UNBULK", for: .normal)
            })
            
        }else{
            //unlike
            PostService.unlikePost(post.id!, completion: {(response) -> Void in
                self.liked = false
                self.bulkButton.setTitle("BULK", for: .normal)
            })
        }
    }
    @IBAction func save(_ sender: Any) {
        if !saved {
            //save
            PostService.savePost(post.id!, completion: {(response) -> Void in
                self.saved = true
                self.saveButton.setTitle("SAVED", for: .normal)
            })
            
        }
    }
    
}
