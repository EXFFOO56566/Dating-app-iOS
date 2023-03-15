//
//  ChangePasswordVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

import Toast
import Async
import QuickdateSDK
class ChangePasswordVC: BaseVC {
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    @IBOutlet weak var forgetLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var currentPwdText: UITextField!
    @IBOutlet var newPwdText: UITextField!
    @IBOutlet var repeatNewPwdText: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideNavigation(hide: true)
        setupUI()
    }
    
    //MARK: - Methods
    func setupUI() {
           self.saveButton.backgroundColor = .Button_StartColor
        self.changePasswordLabel.text = NSLocalizedString("Change Password", comment: "Change Password")
        self.currentPwdText.placeholder = NSLocalizedString("Current Password", comment: "Current Password")
           self.newPwdText.placeholder = NSLocalizedString("New Password", comment: "New Password")
           self.repeatNewPwdText.placeholder = NSLocalizedString("Repeat Password", comment: "Repeat Password")
        self.forgetLabel.text = NSLocalizedString("If you forgot your password, you can reset it from here.", comment: "If you forgot your password, you can reset it from here.")
        self.saveButton.setTitle(NSLocalizedString("SAVE PASSWORD", comment: "SAVE PASSWORD"), for: .normal)
        saveButton.layer.cornerRadius = 8
    }
    private func updatePassword(){
        if (self.currentPwdText.text?.isEmpty)!{
            log.verbose(NSLocalizedString("Please enter Current Password.", comment: "Please enter Current Password."))
            self.view.makeToast(NSLocalizedString("Please enter Current Password.", comment: "Please enter Current Password."))
        }else if (newPwdText.text?.isEmpty)!{
            log.verbose(NSLocalizedString("Please enter New Password..", comment: "Please enter New Password."))
            self.view.makeToast(NSLocalizedString("Please enter New Password.", comment: "Please enter New Password."))
        }else  if (repeatNewPwdText.text?.isEmpty)!{
            log.verbose("Please enter Repeat Password.")
            self.view.makeToast(NSLocalizedString("Please enter Repeat Password.", comment: "Please enter Repeat Password."))
        }else if (newPwdText.text?.isEmpty)! != (repeatNewPwdText.text?.isEmpty)!{
            log.verbose("Password do not match.")
            self.view.makeToast(NSLocalizedString("Please enter Repeat Password.", comment: "Password do not match."))
        }else{
            if Connectivity.isConnectedToNetwork(){
                self.showProgressDialog(text: "Loading...")
                let accessToken = AppInstance.instance.accessToken ?? ""
                let currentPassword = currentPwdText.text ?? ""
                let newPassword = newPwdText.text ?? ""
                let repeatPassword = self.repeatNewPwdText.text ?? ""
                
                Async.background({
                    ProfileManger.instance.changePassoword(AccessToken: accessToken, currentPwd: currentPassword, newPwd: newPassword, repeatNewPwd: repeatPassword, completionBlock: { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.message ?? "")")
                                    self.view.makeToast(success?.data ?? "")
                                    AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                }
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                            })
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                            })
                        }
                    })
                  
                })
            }else{
                log.error("internetErrro = \(InterNetError)")
                self.view.makeToast(InterNetError)
            }
        }
    }
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        self.updatePassword()

    }
}
