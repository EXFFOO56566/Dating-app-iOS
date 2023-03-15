//
//  MyAccountVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class MyAccountVC: BaseVC {
    
    @IBOutlet weak var myAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var countryText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        configView()
        self.setupUI()
        
    }
    
    //MARK:- Methods
    func configView() {
        saveButton.layer.cornerRadius = 8
    }
    
    private func setupUI(){
           self.saveButton.backgroundColor = .Button_StartColor
        self.myAccountLabel.text = NSLocalizedString("My Account", comment: "My Account")
        self.userNameText.placeholder = NSLocalizedString("Username", comment: "Username")
        self.emailText.placeholder = NSLocalizedString("Email", comment: "Email")
        self.phoneText.placeholder = NSLocalizedString("Phone Number", comment: "Phone Number")
         self.countryText.placeholder = NSLocalizedString("Country", comment: "Country")
        self.saveButton.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
            
        
        self.userNameText.text = AppInstance.instance.userProfile?.data?.username ?? ""
        self.emailText.text = AppInstance.instance.userProfile?.data?.email ?? ""
        self.phoneText.text = AppInstance.instance.userProfile?.data?.phoneNumber ?? ""
        self.countryText.text = AppInstance.instance.userProfile?.data?.country ?? ""
    }
   
    private func updateUserAccount(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let username = self.userNameText.text ?? ""
            let email = self.emailText.text ?? ""
            let phoneNo = self.phoneText.text ?? ""
            let country = self.countryText.text ?? ""
            Async.background({
                ProfileManger.instance.updateAccount(AccessToken: accessToken, username: username, email: email, phone: phoneNo, country: country, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                     log.debug("UPDATED")
                                })
                             
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
    
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        updateUserAccount()

    }
}
