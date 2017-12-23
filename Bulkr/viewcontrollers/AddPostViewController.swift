import UIKit

class AddPostViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    var post: Post?
    
    @IBAction func save() {
        print("saved")
        performSegue(withIdentifier: "didAddPost", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddPost"?:
            post = Post(title: titleTextField.text!, description: descriptionTextArea.text)
        default:
            fatalError("Unknown segue")
        
        
    }
    }
}
