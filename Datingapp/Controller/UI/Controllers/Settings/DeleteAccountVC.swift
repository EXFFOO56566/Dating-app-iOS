//
//  DeleteAccountVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

import Async
import QuickdateSDK
class DeleteAccountVC: BaseVC {

    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var removeAccountButton: UIButton!
    @IBOutlet var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        setupUI()
    }
    
    //MARK: - Methods
    func setupUI() {
        self.switcher.onTintColor = .Main_StartColor
        self.switcher.thumbTintColor = .Main_StartColor
         self.removeAccountButton.backgroundColor = .Button_StartColor
        self.deleteAccountLabel.text = NSLocalizedString("Delete Account", comment: "Delete Account")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        self.bottonLabel.text = NSLocalizedString("Yes, I want to delete Username permanently from QuickDate Account.", comment: "Yes, I want to delete Username permanently from QuickDate Account.")
        removeAccountButton.setTitle(NSLocalizedString("REMOVE ACCOUNT", comment: "REMOVE ACCOUNT"), for: .normal)
        
        removeAccountButton.layer.cornerRadius = 8
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeAccountButtonAction(_ sender: Any) {
        if switcher.isOn {
            if self.passwordTextField.text!.isEmpty{
                self.view.makeToast("Please enter password")
            }else{
                self.deleteAccount()
            }
        }else{
            self.view.makeToast("Please verify you want to delete the your account parmanently")
        }
    }
    private func deleteAccount(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let password = self.passwordTextField.text ?? ""
            Async.background({
                UserManager.instance.deleteAccount(AccessToken: accessToken, Password: password, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                let vc = R.storyboard.authentication.main()
                                self.appDelegate.window?.rootViewController = vc
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                    
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
