
import UIKit
import Async
import FBSDKLoginKit
import GoogleSignIn
import QuickdateSDK

class LoginVC: BaseVC {
    @IBOutlet weak var googleIcon: UIImageView!
    @IBOutlet weak var facebookIcon: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var FBSDKButton: FBButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var registeringLabel: UILabel!
    @IBOutlet weak var loginWoWonderBtn: UIButton!
    private var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        log.verbose("Device Id = \(self.deviceID ?? "")")
        
    }
    private func setupUI(){
        
        self.backView.backgroundColor = .Main_StartColor
        self.backView.alpha = 0.55
        self.usernameTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        signUpBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
        forgetPassBtn.setTitle(NSLocalizedString("Forgot Password?", comment: "Forgot Password?"), for: .normal)
        FBSDKButton.setTitle(NSLocalizedString("Continue with Facebook", comment: "Continue with Facebook"), for: .normal)
        googleBtn.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), for: .normal)
        loginWoWonderBtn.setTitle(NSLocalizedString("Login with WoWonder", comment: "Login with WoWonder"), for: .normal)
        
        self.registeringLabel.text = NSLocalizedString("BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE", comment: "BY REGISTERING YOU AGREE TO OUR TERMS OF SERVICE")
        self.haveAccountLabel.text = NSLocalizedString("DON'T HAVE AN ACCOUNT?", comment: "DON'T HAVE AN ACCOUNT?")
        registerBtn.setTitle(NSLocalizedString("REGISTER", comment: "REGISTER"), for: .normal)
        
        self.googleBtn.isHidden = false
        
        self.signUpBtn.cornerRadiusV = self.signUpBtn.frame.height / 2
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        if ControlSettings.showSocicalLogin{
            self.googleIcon.isHidden = false
            self.facebookIcon.isHidden = false
                        self.googleBtn.isHidden = false
            self.loginWoWonderBtn.isHidden = false
            self.FBSDKButton.isHidden = false
        }else{
            self.googleIcon.isHidden = true
            self.facebookIcon.isHidden = true
            self.loginWoWonderBtn.isHidden = true
             self.googleBtn.isHidden = true
            self.FBSDKButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func loginWithWoWonderPressed(_ sender: Any) {
        let vc = R.storyboard.authentication.loginWithWoWonderVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        let vc = R.storyboard.authentication.forgetPasswordVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func registerPressed(_ sender: Any) {
        let vc = R.storyboard.authentication.registerVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        facebookLogin()
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        loginPressed()
        
    }
    
    
    
    private func loginPressed(){
        if appDelegate.isInternetConnected{
            if (self.usernameTextField.text?.isEmpty)!{
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = "Security"
                securityAlertVC?.errorText = "Please enter username."
                self.present(securityAlertVC!, animated: true, completion: nil)
            }else if (passwordTextField.text?.isEmpty)!{
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = "Security"
                securityAlertVC?.errorText = "Please enter password."
                self.present(securityAlertVC!, animated: true, completion: nil)
            }else{
                self.showProgressDialog(text: "Loading...")
                let username = self.usernameTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""
                let deviceID = UserDefaults.standard.getDeviceId(Key:  Local.DEVICE_ID.DeviceId) ?? ""
                Async.background({
                    UserManager.instance.authenticateUser(UserName: username, Password: password, Platform: "iOS", DeviceId: deviceID, completionBlock: { (success, TwoFactorVerify,sessionError, error) in
                        if success != nil{
                            Async.main{
                                self.dismissProgressDialog{
                                    log.verbose("Success = \(success?.data?.accessToken ?? "")")
                                    log.verbose("Success = \(success?.data?.userID ?? 0)")
                                    AppInstance.instance.getUserSession()
                                    AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                        UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
                                        let vc = R.storyboard.authentication.introViewController()
                                        vc?.modalPresentationStyle  =  .fullScreen
                                        self.fetchGifts()
                                        self.fetchStickers()
                                        self.present(vc!, animated: true, completion: nil)
                                        self.view.makeToast("Login Successfull!!")
                                    })
                                }
                            }
                        }else if TwoFactorVerify != nil{
                            self.dismissProgressDialog{
                                self.fetchGifts()
                                self.fetchStickers()
                                log.verbose("Success = \(TwoFactorVerify?.message ?? "")")
                                let vc = R.storyboard.authentication.twoFactorVC()
                                vc?.email = success?.data?.userInfo?.email ?? ""
                                vc?.code = TwoFactorVerify?.code ?? 0
                                vc?.userID = TwoFactorVerify?.userID ?? 0
                                vc?.password = self.passwordTextField.text ?? ""
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        } else if sessionError != nil{
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
                    })
                })
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
extension LoginVC:GIDSignInDelegate{
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
