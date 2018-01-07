import UIKit
import MaterialComponents.MaterialSnackbar

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isLoggedIn() == true {
            self.view.isHidden = true
        } else {
            self.view.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn() == true {
            performSegue(withIdentifier: "loggedInSegue", sender: self)
        }

    }
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor.darkText
        
        emailTextField.setBottomLine(in: lineColor)
        passwordTextField.setBottomLine(in: lineColor)
        
    }
    
    func isLoggedIn() -> Bool {
        if UserDefaults.standard.string(forKey: "token") != nil{
            if UserDefaults.standard.string(forKey: "userMail") != nil {
                return true
            } else {
                return false
            }
        }else{
            print("no token")
            return false
        }
    }
 
    @IBAction func unwindFromLogout(_ segue: UIStoryboardSegue){
        switch segue.identifier {
        case "didLogout"?:
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userMail")
        default:
            fatalError("Unknown segue")
            
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UserService.login(as: email, with: password, completion: {(response) -> Void in
            print("logged in in screen")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.performSegue(withIdentifier: "loggedInSegue", sender: self)
        }, failure: {(message) -> Void in
            let sMessage = MDCSnackbarMessage()
            sMessage.text = "We could not log you in."
            MDCSnackbarManager.show(sMessage)
        })
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}


