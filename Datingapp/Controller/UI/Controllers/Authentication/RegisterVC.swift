

import UIKit
import Async
import QuickdateSDK
import GoogleSignIn
import FBSDKLoginKit
class RegisterVC: BaseVC {
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var googleIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var genderTextField: CustomTextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var signiNBTN: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var registeringLabel: UILabel!
    var gender:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    private func setupUI(){
        self.backView.backgroundColor = .Main_StartColor
              self.backView.alpha = 0.55
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.emailTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "Username")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        self.confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "Confirm Password")
//        self.genderBtn.setTitle(NSLocalizedString("Gender", comment: "Gender"), for: .normal)
        self.createAccountBtn.setTitle(NSLocalizedString("CREATE AN ACCOUNT", comment: "CREATE AN ACCOUNT"), for: .normal)
        self.facebookBtn.setTitle(NSLocalizedString("Continue with Facebook", comment: "Continue with Facebook"), for: .normal)
        self.googleBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
       
        self.registeringLabel.text = NSLocalizedString("BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE", comment: "BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE")
        self.haveAccountLabel.text = NSLocalizedString("DON'T HAVE AN ACCOUNT?", comment: "DON'T HAVE AN ACCOUNT?")
        signiNBTN.setTitle(NSLocalizedString("SIGN IN", comment: "SIGN IN"), for: .normal)
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        if ControlSettings.showSocicalLogin{
            self.googleIcon.isHidden = false
            self.facebookIcon.isHidden = false
                        self.googleBtn.isHidden = false
            self.facebookBtn.isHidden = false
        }else{
            self.googleIcon.isHidden = true
            self.facebookIcon.isHidden = true
             self.googleBtn.isHidden = true
            self.facebookBtn.isHidden = true
        }
    }
    
    
    @IBAction func googlePressed(_ sender: Any) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        
        self.facebookLogin()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        self.registerPressed()
    }
    @IBAction func signInPressed(_ sender: Any) {
        let vc = R.storyboard.authentication.loginVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func genderPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Gender", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let male = UIAlertAction(title: "MALE", style: .default) { (action) in
            self.gender = "Male"
            self.genderTextField.text = "male"
        }
        let female = UIAlertAction(title: "FEMALE", style: .default) { (action) in
            self.gender = "female"
            self.genderTextField.text = "Female"
        }
        
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func registerPressed(){
        if appDelegate.isInternetConnected{
            if (self.firstNameTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter first name.", comment: "Please enter first name.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.lastNameTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter last name.", comment: "Please enter last name.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.emailTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter username.", comment: "Please enter username.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.usernameTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter email.", comment: "Please enter email.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.passwordTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter password.", comment: "Please enter password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.confirmPasswordTextField.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter confirm password.", comment: "Please enter confirm password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (self.passwordTextField.text != self.confirmPasswordTextField.text){
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Password do not match.", comment: "Password do not match.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if !((emailTextField.text?.isEmail)!){
                
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  =  NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }
            else{
                let alert = UIAlertController(title: "", message:NSLocalizedString("By registering you agree to our terms of service", comment: "By registering you agree to our terms of service") , preferredStyle: .alert)
                let okay = UIAlertAction(title: NSLocalizedString("OKAY", comment: "OKAY"), style: .default) { (action) in
                    self.registerPressedfunc()
                }
                let termsOfService = UIAlertAction(title:NSLocalizedString("TERMS OF SERVICE", comment: "TERMS OF SERVICE") , style: .default) { (action) in
                    let url = URL(string: "\(ControlSettings.baseURL)terms")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                            print("Open url : \(success)")
                        })
                    }
                }
                let privacy = UIAlertAction(title: "PRIVACY", style: .default) { (action) in
                    let url = URL(string: "\(ControlSettings.baseURL)privacy")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                            print("Open url : \(success)")
                        })
                    }
                }
                alert.addAction(termsOfService)
                alert.addAction(privacy)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.errorText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
    }
    private func registerPressedfunc(){
        self.showProgressDialog(text: "Loading...")
        let firstName = self.firstNameTextField.text  ?? ""
        let lastName = self.lastNameTextField.text  ?? ""
        let username = self.usernameTextField.text ?? ""
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        let deviceId = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId) ?? ""
        
        Async.background({
            UserManager.instance.registerUser(FirstName:firstName, LastName: lastName, Email: email, UserName: username, Password: password, DeviceId: deviceId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main{
                        self.dismissProgressDialog{
                            //                            log.verbose("Success = \(success?.data?.accessToken ?? "")")
                            //                            AppInstance.instance.getUserSession()
                            
                            //                            AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                            //
                            //                            })
                            UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
                            // let vc = R.storyboard.authentication.introViewController()
                            let vc = R.storyboard.authentication.twoFactorVC()
                            vc?.email = email
                            vc?.is_check = "1"
                            self.navigationController?.pushViewController(vc!, animated: true)
                            self.view.makeToast("SignUP Successfull!!")                       }
                        
                    }
                    
                }else if sessionError != nil{
                    Async.main{
                        
                        self.dismissProgressDialog {
                            log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                            let securityAlertVC = R.storyboard.popUps.securityPopVC()
                            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                            securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                            self.present(securityAlertVC!, animated: true, completion: nil)
                        }
                    }
                    
                }else {
                    Async.main({
                        
                        self.dismissProgressDialog {
                            log.verbose("error = \(error?.localizedDescription ?? "")")
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
    private func facebookLogin(){
        if Connectivity.isConnectedToNetwork(){
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                if (error == nil){
                    self.showProgressDialog(text: "Loading...")
                    let fbloginresult : LoginManagerLoginResult = result!
                    if (result?.isCancelled)!{
                        self.dismissProgressDialog{
                            log.verbose("result.isCancelled = \(result?.isCancelled ?? false)")
                        }
                        return
                    }
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((AccessToken.current) != nil){
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        let dict = result as! [String : AnyObject]
                                        log.debug("result = \(dict)")
                                        guard (dict["first_name"] as? String) != nil else {return}
                                        guard (dict["last_name"] as? String) != nil else {return}
                                        guard (dict["email"] as? String) != nil else {return}
                                        let accessToken = AccessToken.current?.tokenString
                                        log.verbose("FaceBookaccessToken = \(accessToken)")
                                        self.dismissProgressDialog {
                                            log.verbose("FaceBookaccessToken = \(accessToken)")
                                        }
                                        let FBAccessToken = accessToken ?? ""
                                        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
                                        
                                        Async.background({
                                            UserManager.instance.socialLogin(accessToken: FBAccessToken, Provider: "facebook", DeviceId:  deviceID, googleApiKey: "") { (success, sessionError, error) in
                                                if success != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog{
                                                            log.verbose("Success = \(success?.message ?? "")")
                                                            AppInstance.instance.getUserSession()
                                                            AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                                                let vc = R.storyboard.authentication.introViewController()
                                                                vc?.modalPresentationStyle  =  .fullScreen
                                                                self.fetchGifts()
                                                                self.fetchStickers()
                                                                self.present(vc!, animated: true, completion: nil)
                                                                self.view.makeToast("Login Successfull!!")
                                                            })
                                                            
                                                            
                                                        }
                                                        
                                                    }
                                                }else if sessionError != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog {
                                                            log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                                                            
                                                            let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                                            securityAlertVC?.titleText  = "Security"
                                                            securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                            
                                                        }
                                                    }
                                                }else {
                                                    Async.main({
                                                        self.dismissProgressDialog {
                                                            log.verbose("error = \(error?.localizedDescription ?? "")")
                                                            let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                                            securityAlertVC?.titleText  = "Security"
                                                            securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                        }
                                                    })
                                                }
                                            }
                                        })
                                        log.verbose("FBSDKAccessToken.current() = \(AccessToken.current?.tokenString ?? "")")
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = "Internet Error"
                securityAlertVC?.errorText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
    }
    private func googleLogin(access_Token:String){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
        if Connectivity.isConnectedToNetwork(){
            Async.background({
                UserManager.instance.socialLogin(accessToken: access_Token, Provider: "google", DeviceId: deviceID, googleApiKey: ControlSettings.googleApiKey, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main{
                            self.dismissProgressDialog{
                                log.verbose("Success = \(success?.data?.accessToken ?? "")")
                                AppInstance.instance.getUserSession()
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                    let vc = R.storyboard.authentication.introViewController()
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    self.view.makeToast(NSLocalizedString("Login Successfull!!", comment: "Login Successfull!!"))
                                })
                            }
                        }
                    }else if sessionError != nil{
                        Async.main{
                            self.dismissProgressDialog {
                                log.verbose("session Error = \(sessionError?.errors?.errorText)")
                                
                                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                                
                            }
                        }
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.verbose("error = \(error?.localizedDescription)")
                                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                            }
                        })
                    }
                })
            })
            
            
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.errorText = InterNetError ?? ""
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        } 
    }
}
extension RegisterVC:GIDSignInDelegate{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            _ = user.userID ?? ""
            log.verbose("user auth = \(user.authentication.accessToken ?? "")")
            let accessToken = user.authentication.idToken ?? ""
            self.googleLogin(access_Token: user.authentication.idToken)
        } else {
            log.error(error.localizedDescription)
        }
    }
}
