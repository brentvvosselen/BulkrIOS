import UIKit

class PostCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: Post! {
        didSet{
            titleLabel.text = post.title
            posterLabel.text = post.poster?.email
            descriptionLabel.text = post.description
            print("set post")
        }
    }
}
