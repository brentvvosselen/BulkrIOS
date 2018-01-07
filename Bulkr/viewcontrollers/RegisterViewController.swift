import UIKit
import MaterialComponents.MaterialSnackbar

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLayoutSubviews() {
        let linecolor = UIColor.darkText
        
        emailTextField.setBottomLine(in: linecolor)
        passwordTextField.setBottomLine(in: linecolor)
        passwordConfirmTextField.setBottomLine(in: linecolor)
    }
    
    @IBAction func register(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let passwordConfirm = passwordConfirmTextField.text!
        
        if password == passwordConfirm {
            if isValidEmail(email) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                UserService.register(with: email, and: password, completion: {(response) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.dismiss(animated: false)
                }, failure: {(message) -> Void in
                    let sMessage = MDCSnackbarMessage()
                    sMessage.text = message
                    MDCSnackbarManager.show(sMessage)
                })
            } else {
                showAlert(with: "Not a valid email!")
            }
        }else {
            showAlert(with: "Passwords are not the same!")
        }
    }
    @IBAction func goToLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showAlert(with message: String){
        let alertController = UIAlertController(title: NSLocalizedString("Failed",comment:""), message: NSLocalizedString(message,comment:""), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:     NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

