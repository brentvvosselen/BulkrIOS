import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var post: Post! {
        didSet{
            titleLabel.text = post.title
            print("set post")
        }
    }
}
