import UIKit

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
        if let token = UserDefaults.standard.string(forKey: "token"){
            print("token")
            return true
        }else{
            print("no token")
            return false
        }
    }
 
    @IBAction func unwindFromLogout(_ segue: UIStoryboardSegue){
        switch segue.identifier {
        case "didLogout"?:
            UserDefaults.standard.removeObject(forKey: "token")
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
        })
    }
}


