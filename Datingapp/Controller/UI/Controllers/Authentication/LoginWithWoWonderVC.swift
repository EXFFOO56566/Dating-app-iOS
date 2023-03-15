//
//  LoginWithWoWonderVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 8/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

import QuickdateSDK
import Async

class LoginWithWoWonderVC: BaseVC {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    var error = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        hideNavigation(hide: false)
    }
    private func setupUI(){
        self.userNameField.placeholder = NSLocalizedString("Username", comment: "Username")
         self.passwordField.placeholder = NSLocalizedString("Password", comment: "Password")
        self.signInBtn.setTitle(NSLocalizedString("Sign in", comment: "Sign in"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignIn(_ sender: Any) {
        
        if self.userNameField.text?.isEmpty == true {
            self.view.makeToast("Error, Required Username")
        }
        else if self.passwordField.text?.isEmpty == true {
            
            self.view.makeToast("Error, Required Password")
            
        }
        else {
            self.loginAuthentication()
        }
        
    }
    
    private func loginAuthentication () {
        self.showProgressDialog(text: "Loading...")
        let username = self.userNameField.text ?? ""
        let password = self.passwordField.text ?? ""
        
        Async.background({
            UserManager.instance.loginWithWoWonder(userName: username, password: password) { (success, sessionError, error) in
                if success != nil {
                    self.dismissProgressDialog {
                        log.verbose("Login Succesfull =\(success?.accessToken)")
                        self.WowonderSignIn(userID: success?.userID ?? "", accessToken: success?.accessToken ?? "")
                    }
                }
                else if sessionError != nil {
                    self.dismissProgressDialog {
                        self.error = sessionError?.errors.errorText ?? ""
                        log.verbose(sessionError?.errors.errorText ?? "")
                        self.view.makeToast(sessionError?.errors.errorText ?? "")
                    }
                }
                else if error != nil{
                    self.dismissProgressDialog {
                        print("error - \(error?.localizedDescription)")
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        })
    }
    private func WowonderSignIn (userID:String, accessToken:String) {
        self.showProgressDialog(text: "Loading...")
        let username = self.userNameField.text ?? ""
        let password = self.passwordField.text ?? ""
        let deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId) ?? ""
        
        Async.background({
            WoWProfileManager.instance.WoWonderUserData(userId: userID, access_token: accessToken) { (success, sessionError, error) in
                if success != nil {
                    self.dismissProgressDialog {
                        log.verbose("Login Succesfull =\(success?.accessToken)")
                        log.verbose("Success = \(success?.accessToken ?? "")")
                        AppInstance.instance.getUserSession()
                        AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                            let vc = R.storyboard.authentication.introViewController()
                            self.navigationController?.pushViewController(vc!, animated: true)
                            self.view.makeToast("Login Successfull!!")
                        })
                        
                    }
                }
                else if sessionError != nil {
                    self.dismissProgressDialog {
                        self.error = sessionError?.errors?.errorText ?? ""
                        log.verbose(sessionError?.errors?.errorText ?? "")
                        self.view.makeToast(sessionError?.errors?.errorText ?? "")
                    }
                }
                else if error != nil{
                    self.dismissProgressDialog {
                        print("error - \(error?.localizedDescription)")
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        })
    }
    
}

