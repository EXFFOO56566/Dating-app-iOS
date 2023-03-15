//
//  TwoFactorVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 6/2/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async

class TwoFactorVC: BaseVC {
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    var code:Int? = 0
    var userID : Int? = 0
    var error = ""
    var password:String? = ""
    var email = ""
    var is_check = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI(){
        self.verifyBtn.setTitleColor(.Button_StartColor, for: .normal)
        self.firstLabel.text = NSLocalizedString("To log in, you need to verify  your identity.", comment: "To log in, you need to verify  your identity.")
        self.secondLabel.text = NSLocalizedString("We have sent you the confirmation code to your email address.", comment: "We have sent you the confirmation code to your email address.")
        self.verifyCodeTextField.placeholder =  NSLocalizedString("Add code number", comment: "Add code number")
        self.verifyBtn.setTitle(NSLocalizedString("VERIFY", comment: "VERIFY"), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.resendEmail()
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func verifyPressed(_ sender: Any) {
        if self.verifyCodeTextField.text!.isEmpty{
            self.view.makeToast("Please enter Code")
        }else{
            if (self.is_check == "1"){
                self.activateAccount()
            }
            else{
                self.verifyTwoFactor()
            }
        }
    }
    
    
    @IBAction func ResendEmail(_ sender: Any) {
            self.resendEmail()
    }
    
    private func resendEmail(){
        if appDelegate.isInternetConnected{
                ResendEmailManager.sharedInstance.resendEmail(email: self.email) { (success,authError, error) in
                    if (success != nil){
                        self.view.makeToast(success?.message ?? "")
                    }
                    else if (authError != nil){
                        self.view.makeToast(authError?.errorText)
                    }
                    else if (error != nil){
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
        }
        else{
            let securityAlertVC = R.storyboard.popUps.securityPopVC()
            securityAlertVC?.titleText  = "Internet Error"
            securityAlertVC?.errorText = InterNetError ?? ""
            self.present(securityAlertVC!, animated: true, completion: nil)
            log.error("internetError - \(InterNetError)")
        }
    }
    
    
    private func activateAccount(){
        if appDelegate.isInternetConnected{
            self.showProgressDialog(text: "Loading")
            ActivatedAccountManager.sharedInstance.activateAccount(code: Int(self.verifyCodeTextField.text!) ?? 0, email: self.email) { (success, authError, error) in
                if (success != nil){
                    self.dismissProgressDialog {
                        AppInstance.instance.getUserSession()
                        AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
//                            UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
                            let vc = R.storyboard.authentication.introViewController()
                            vc?.modalPresentationStyle  =  .fullScreen
                            self.fetchGifts()
                            self.fetchStickers()
                            self.present(vc!, animated: true, completion: nil)
                        })
                    }
                    self.view.makeToast(success?.message)
                }
                else if (authError != nil){
                    self.dismissProgressDialog {
                        self.view.makeToast(authError?.errors.errorText)
                    }
                }
                else if (error != nil){
                    self.dismissProgressDialog {
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
        else{
            let securityAlertVC = R.storyboard.popUps.securityPopVC()
            securityAlertVC?.titleText  = "Internet Error"
            securityAlertVC?.errorText = InterNetError ?? ""
            self.present(securityAlertVC!, animated: true, completion: nil)
            log.error("internetError - \(InterNetError)")
        }
    }
    
    private func verifyTwoFactor(){
        
        if appDelegate.isInternetConnected{
            if (self.verifyCodeTextField.text!.isEmpty){
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = "Security"
                securityAlertVC?.errorText = "Please enter Code."
                self.present(securityAlertVC!, animated: true, completion: nil)
            }else{
                self.showProgressDialog(text: "Loading...")
                let userID = self.userID ?? 0
                let code = self.verifyCodeTextField.text ?? ""
                
                Async.background({
                    UserManager.instance.verifyTwoFactor(userId: userID, code: Int(code )!) { (success, sessionError, error) in
                        if success != nil{
                            Async.main{
                                self.dismissProgressDialog{
                                    log.verbose("Success = \(success?.data?.accessToken ?? "")")
                                    log.verbose("Success = \(success?.data?.userID ?? 0)")
                                    AppInstance.instance.getUserSession()
                                    AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                        UserDefaults.standard.setPassword(value: self.password ?? "", ForKey: Local.USER_SESSION.Current_Password)
                                        let vc = R.storyboard.authentication.introViewController()
                                        vc?.modalPresentationStyle  =  .fullScreen
                                        self.present(vc!, animated: true, completion: nil)
                                        self.view.makeToast("Login Successfull!!")
                                    })
                                }
                            }
                        }else if sessionError != nil{
                            Async.main{
                                self.dismissProgressDialog {
                                    log.verbose("session Error = \(sessionError?.errors?.errorText)")
                                    
                                    let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                    securityAlertVC?.titleText  = "Security"
                                    securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                    self.present(securityAlertVC!, animated: true, completion: nil)
                                    
                                }
                            }
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.verbose("error = \(error?.localizedDescription)")
                                    let securityAlertVC = R.storyboard.popUps.securityPopVC()
                                    securityAlertVC?.titleText  = "Security"
                                    securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                    self.present(securityAlertVC!, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                    
                })
            }
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popUps.securityPopVC()
                securityAlertVC?.titleText  = "Internet Error"
                securityAlertVC?.errorText = InterNetError ?? ""
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
    }
}
