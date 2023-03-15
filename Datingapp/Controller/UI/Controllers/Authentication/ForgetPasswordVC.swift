
import UIKit
import Async
import QuickdateSDK
class ForgetPasswordVC: BaseVC {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var forgetLabel: UILabel!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var forgetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        self.setupUI()
        
        
    }
    @IBAction func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if self.emailTextField.text!.isEmpty{
            let securityAlertVC = R.storyboard.popUps.securityPopVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Please enter email."
            self.present(securityAlertVC!, animated: true, completion: nil)
            
        }else if !self.emailTextField.text!.isEmail{
            let securityAlertVC = R.storyboard.popUps.securityPopVC()
            securityAlertVC?.titleText  = "Security"
            securityAlertVC?.errorText = "Email is badly formatted."
            self.present(securityAlertVC!, animated: true, completion: nil)
            
        }else{
            self.send()
        }
    }
    private func setupUI(){
        self.forgetLabel.text = NSLocalizedString("Forget Password", comment: "Forget Password")
        self.topLabel.text = NSLocalizedString("Please enter your email address. We will send you a link to reset password.", comment: "Please enter your email address. We will send you a link to reset password.")
        self.forgetBtn.setTitle(NSLocalizedString("Send", comment: "Send"), for: .normal)
        
        forgetBtn.setGradientBackground(colorOne: .Main_StartColor, colorTwo: .Main_EndColor, horizontal: true)
    }
    
    private func send(){
        self.showProgressDialog(text: "Loading...")
        let email = emailTextField.text ?? ""
        Async.background({
            UserManager.instance.forgetPassword(Email: email, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            log.debug("userList = \(success)")
//                            self.view.makeToast(success)
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            let securityAlertVC = R.storyboard.popUps.securityPopVC()
                            securityAlertVC?.titleText  = "Security"
                            securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                            self.present(securityAlertVC!, animated: true, completion: nil)
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            
                            let securityAlertVC = R.storyboard.popUps.securityPopVC()
                            securityAlertVC?.titleText  = "Security"
                            securityAlertVC?.errorText = error?.localizedDescription ?? ""
                            self.present(securityAlertVC!, animated: true, completion: nil)
                        }
                    })
                }
            })
        })
    }
}
