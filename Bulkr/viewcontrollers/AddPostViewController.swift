import UIKit
import MaterialComponents.MaterialSnackbar

class AddPostViewController: UITableViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
 {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextArea: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var choosePictureButton: UIButton!
    
    var post: Post?
    var image: Image?
    
    // Source: https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
    @IBAction func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Oops!",
                                    message: "We cannot get access to your camera!",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
        
    }
    
    @IBAction func choosePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Oops!",
                                    message: "We cannot get access to your library!",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    @IBAction func save() {
        print("saved")
        performSegue(withIdentifier: "didAddPost", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddPost"?:
            post = Post(title: titleTextField.text!, description: descriptionTextArea.text)
            post?.picture = self.image
        default:
            fatalError("Unknown segue")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("image: ")
        pictureImageView.image = image
        dismiss(animated:true, completion: nil)
        
        if let cimageData = image.jpeg(.lowest) {
            let compressedBase64 = cimageData.base64EncodedString(options: .lineLength64Characters)
            print("Compressed \(compressedBase64.lengthOfBytes(using: .utf8))")
            let timestamp = NSDate().timeIntervalSince1970
            
            let image = Image(filename: String(timestamp), filetype: "image/jpeg", value: compressedBase64)
            
            self.image = image
            print(image)
        }
        
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
   
}
