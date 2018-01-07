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
    
    var post: Post!{
        didSet{
            print("setted")
            titleLabel.text = post.title
            posterLabel.text = post.poster?.email
            descriptionLabel.text = post.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            
            dateFormatter.locale = Locale(identifier: "en_US")
            if let date = post.createdAt {
                dateLabel.text = dateFormatter.string(from: date)
                
            }
     
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
            if let likes = post.likes {
                print("user not liked")
                liked = false
                bulkButton.setTitle("\(likes.count) BULK" , for: .normal)
                for user in likes {
                    if user.email == UserDefaults.standard.string(forKey: "userMail") {
                        print("user liked")
                        liked = true
                        bulkButton.setTitle("\(likes.count) UNBULK" , for: .normal)
                    }
                }
            }else{
                bulkButton.setTitle("\(0) BULK" , for: .normal)
                liked = false
                print("setted false")
            }
            
            
            //check if saved
            if let saves = post.saves {
                for user in saves {
                    if user.email == UserDefaults.standard.string(forKey: "userMail") {
                        saved = true
                        saveButton.setTitle("SAVED", for: .normal)
                        saveButton.isEnabled = false
                    }
                }
            }
           
        }
    }
    @IBAction func bulk(_ sender: Any) {
        print("bulk_click")
        print(liked)
        if !liked {
            //like
            print("like")
            PostService.likePost(post.id!, completion: {(response) -> Void in
                self.post = response
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
            
        }else{
            //unlike
            print("unlike")
            PostService.unlikePost(post.id!, completion: {(response) -> Void in
                self.post = response
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
                self.post = response
            }, failure: {(message) -> Void in
                let sMessage = MDCSnackbarMessage()
                sMessage.text = message
                MDCSnackbarManager.show(sMessage)
            })
            
        }
    }
    
}
