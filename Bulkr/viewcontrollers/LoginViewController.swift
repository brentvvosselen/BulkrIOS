import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor.darkText
        
        emailTextField.setBottomLine(in: lineColor)
        passwordTextField.setBottomLine(in: lineColor)
        
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UserService.login(as: email, with: password, completion: {(response) -> Void in
            print("logged in in screen")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
}


