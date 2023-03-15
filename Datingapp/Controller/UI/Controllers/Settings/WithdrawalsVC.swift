//
//  WithdrawalsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
class WithdrawalsVC: BaseVC {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var widthdrawalLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    var email:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    private func setupUI(){
        self.balanceLabel.text = NSLocalizedString("MY BALANCE", comment: "MY BALANCE")
        self.amountText.placeholder = NSLocalizedString("Amount", comment: "Amount")
        self.emailTextField.placeholder = NSLocalizedString("PayPal E-mail", comment: "PayPal E-mail")
        self.amountLabel.text = "$"+(AppInstance.instance.userProfile?.data?.balance)! ?? ""
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let amountValue = self.amountText.text ?? ""
        let accessToken = AppInstance.instance.accessToken ?? ""
        if Int(amountValue) ?? 0 >= 50 && !self.emailTextField.text!.isEmpty{
            self.showProgressDialog(text: "Loading...")
            let email = self.emailTextField.text ?? ""
            Async.background({
                WithdrawalsManager.instance.requestWithdrawals(AccessToken: accessToken, amount: amountValue, email: email) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("success = \(success?.message)")
                                self.view.makeToast(success?.message)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                self.view.makeToast(sessionError?.errors?.errorText)
                            }
                            
                        })
                        
                    }else {
                        
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                                self.view.makeToast(error?.localizedDescription)
                            }
                            
                        })
                    }
                }
            })
        }else if amountValue == nil {
            self.view.makeToast(NSLocalizedString("Please enter amount.", comment: "Please enter amount."))
        }else if self.emailTextField.text!.isEmpty{
            self.view.makeToast(NSLocalizedString("Please enter email.", comment: "Please enter email."))
        }else if !self.emailTextField.text!.isEmail{
            self.view.makeToast(NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted."))
        }
        else{
            self.view.makeToast(NSLocalizedString("Amount shouldn't be less than 50.", comment: "Amount shouldn't be less than 50."))
        }
    }
    
}
