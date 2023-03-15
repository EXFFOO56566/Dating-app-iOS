//
//  UpdateTwoFactorSettingPopupVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/30/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK

class UpdateTwoFactorSettingPopupVC: BaseVC {
    
    @IBOutlet weak var codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendPressed(_ sender: Any) {
        if self.codeTextField.text!.isEmpty{
            self.view.makeToast(NSLocalizedString("Please enter code", comment: "Please enter code"))
        }else{
            self.verifyCode(code: self.codeTextField.text ?? "", Type: "verify")
        }
    }
    private func verifyCode(code:String,Type:String){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let userID = AppInstance.instance.userId ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        Async.background({
            ProfileManger.instance.verifyTwoFactorCode(UserId: userID, AccessToken: accessToken, twoFactorCode: code) { (success, sessionError, error) in
                 if success != nil{
                                   Async.main({
                                       self.dismissProgressDialog {
                                           self.view.makeToast(success?.message ?? "")
                                        AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                           
                                       }
                                   })
                               }else if sessionError != nil{
                                   Async.main({
                                       self.dismissProgressDialog {
                                        self.view.makeToast(sessionError?.errors?.errorText)
                                        log.error("sessionError = \(sessionError?.errors?.errorText)")
                                           
                                       }
                                   })
                               }else {
                                   Async.main({
                                       self.dismissProgressDialog {
                                           self.view.makeToast(error?.localizedDescription)
                                           log.error("error = \(error?.localizedDescription)")
                                       }
                                   })
                               }
            }
        })
    }
}
