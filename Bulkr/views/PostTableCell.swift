import UIKit
import MaterialComponents.MaterialSnackbar

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
    var likes: Int = 0
    
    var currentUser: String = "brent.vanvosselen@live.be"
    
    var post: Post!{
        didSet{
            titleLabel.text = post.title
            posterLabel.text = post.poster?.email
            descriptionLabel.text = post.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateLabel.text = dateFormatter.string(from: post.createdAt!)
            
            if let like = post.likes{
                likes = like.count
            }
            
            bulkButton.setTitle("\(likes) BULK" , for: .normal)
            
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
                    bulkButton.setTitle("\(likes) UNBULK" , for: .normal)
                }
            }
            
            //check if saved
            for user in post.saves! {
                if user.email == currentUser {
                    saved = true
                    saveButton.setTitle("SAVED", for: .normal)
                    saveButton.isEnabled = false
                }
            }
        }
    }
    @IBAction func bulk(_ sender: Any) {
        print("bulk_click")
        if !liked {
            //like
            PostService.likePost(post.id!, completion: {(response) -> Void in
                self.liked = true
                self.likes += 1
                self.bulkButton.setTitle("\(self.likes) UNBULK" , for: .normal)
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
            
        }else{
            //unlike
            PostService.unlikePost(post.id!, completion: {(response) -> Void in
                self.liked = false
                self.likes -= 1
                self.bulkButton.setTitle("\(self.likes) BULK" , for: .normal)
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
        }
    }
    @IBAction func save(_ sender: Any) {
        print("save_click")
        if !saved {
            //save
            PostService.savePost(post.id!, completion: {(response) -> Void in
                self.saved = true
                self.saveButton.setTitle("SAVED", for: .normal)
                self.saveButton.isEnabled = false
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
            
        }
    }
    
}
