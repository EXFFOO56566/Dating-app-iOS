//
//  UpgradeAccountVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import PassKit
import Async
struct UpgradeDataSetClass{
    var planName:String?
    var planMoney:String?
    var planTyle:String?
    var planColor:UIColor?
    
}
class UpgradeAccountVC: BaseVC {
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var moreSticket: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var activatingLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    
    @IBOutlet weak var likeNotification: UILabel!
    
    
    @IBOutlet weak var displayOnToPLabel: UILabel!
    @IBOutlet weak var displayFirstLabel: UILabel!
    @IBOutlet weak var getDiscountLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSet = [UpgradeDataSetClass()]
    var delegate:movetoPayScreenDelegate?
    var paymentDelegate : didSelectPaymentDelegate?
    var paymentRequest: PKPaymentRequest!
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    
    var transactionId = ""
    var status = ""
    var amount = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        skipBtn.setTitleColor(.Main_StartColor, for: .normal)
        self.upgradeLabel.text = NSLocalizedString("Upgrade To Premium", comment: "Upgrade To Premium")
        self.activatingLabel.text = NSLocalizedString("Activating Premium will help you meet more people, faster.", comment: "Activating Premium will help you meet more people, faster.")
        self.moreSticket.text = NSLocalizedString("See more stickers on chat.", comment: "See more stickers on chat")
        self.premiumLabel.text = NSLocalizedString("Show in Premium bar", comment: "Show in Premium bar")
        self.likeNotification.text = NSLocalizedString("See like notifications", comment: "See like notifications")
        self.premiumLabel.text = NSLocalizedString("Show in Premium bar", comment: "Show in Premium bar")
        self.getDiscountLabel.text = NSLocalizedString("Get discount when buy boost me", comment: "Get discount when buy boost me")
        self.displayFirstLabel.text = NSLocalizedString("Display first in find matches", comment: "Display first in find matches")
        self.displayOnToPLabel.text = NSLocalizedString("Display on top in random users", comment: "Display on top in random users")
        self.skipBtn.setTitle(NSLocalizedString("Skip Premium", comment: "Skip Premium"), for: .normal)
        
        self.paymentDelegate = self
        
        collectionView.register(R.nib.upgradeAccountCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.upgradeAccountCollectionItem.identifier)
        self.dataSet = [
            UpgradeDataSetClass(planName: "Weekly", planMoney: "8 $", planTyle: "Normal", planColor: UIColor.hexStringToUIColor(hex: "912F86")),
            UpgradeDataSetClass(planName: "Monthly", planMoney: "25 $", planTyle: "Save 51%", planColor: UIColor.hexStringToUIColor(hex: "F3CE80")),
            UpgradeDataSetClass(planName: "Yearly", planMoney: "280 $", planTyle: "Save 90%", planColor: UIColor.hexStringToUIColor(hex: "B11B42")),
            UpgradeDataSetClass(planName: "Lifetime", planMoney: "500 $", planTyle: "Pay ones access for ever", planColor: UIColor.hexStringToUIColor(hex: "77A6EE")),
        ]
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func selectPayment(Index:Int){
        let alert = UIAlertController(title: NSLocalizedString("Select Payment", comment: "Select Payment"), message: "", preferredStyle: .actionSheet)
        let payPal = UIAlertAction(title:NSLocalizedString("Paypal", comment: "Paypal"), style: .default) { (action) in
            self.paymentDelegate?.selectPayment(status: true, type: "Paypal", Index: Index, PaypalCredit: self.dataSet[Index].planMoney?.toInt())
        }
        let creditCard = UIAlertAction(title:NSLocalizedString("Credit Card", comment: "Credit Card") , style: .default) { (action) in
            
            self.paymentDelegate?.selectPayment(status: true, type: "creditCard", Index: Index, PaypalCredit: nil)
            
        }
        let bankTransfer = UIAlertAction(title: NSLocalizedString("Bank Transfer", comment: "Bank Transfer"), style: .default) { (action) in
            
            self.paymentDelegate?.selectPayment(status: false, type: "bankTransfer", Index: Index, PaypalCredit: nil)
            
            
        }
        
        let applePay = UIAlertAction(title: "Apple Pay", style: .default) { (action) in
            //               self.paymentDelegate?.selectPayment(status: false, type: "applePay", Index:Index, PaypalCredit: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive) { (action) in
            
        }
        alert.addAction(payPal)
        alert.addAction(creditCard)
        alert.addAction(bankTransfer)
//        alert.addAction(applePay)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func startCheckout(amount:Int,memberShipType:Int) {
        braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest(amount: "\(amount ?? 0)")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                
                
                self.setPro(through: "paypal", amount: amount, memberShipType: memberShipType)
                
            } else if let error = error {
                log.verbose("error = \(error.localizedDescription ?? "")")
            } else {
                log.verbose("error = \(error?.localizedDescription ?? "")")
            }
        }
    }
    private func setPro(through:String,amount: Int, memberShipType: Int){
        
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let amountInt = amount ?? 0
            let membershipTypeInt = memberShipType ?? 0
            
            Async.background({
                SetProManager.instance.setPro(AccessToken: accessToken, Type: membershipTypeInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.dismiss(animated: true, completion: nil)
                                
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
extension UpgradeAccountVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.upgradeAccountCollectionItem.identifier, for: indexPath) as? UpgradeAccountCollectionItem
        
        let object = self.dataSet[indexPath.row]
        cell?.bind(object)
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectPayment(Index: indexPath.row)
    }
    
}

extension UpgradeAccountVC:didSelectPaymentDelegate{
    func selectPayment(status: Bool, type: String, Index: Int,PaypalCredit:Int?) {
        if type == "creditCard"{
            if Index == 0{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "membership", amount: 8, description: "Weekly", membershipType: 1, credits: 0)
                }
                
            }else if Index == 1{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "membership", amount: 25, description: "Monthly", membershipType: 2, credits: 0)
                }
                
            }else if Index == 2{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "membership", amount: 280, description: "Yearly", membershipType: 3, credits: 0)
                }
                
            }else if Index == 3{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "membership", amount: 500, description: "Lifetime", membershipType: 4, credits: 0)
                }
                
            }
            
        } else if type == "bankTransfer"{
            if Index == 0{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "membership", amount: 8, description: "Weekly", membershipType: 1, credits: 0)
                }
                
            }else if Index == 1{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "membership", amount: 25, description: "Monthly", membershipType: 2, credits: 0)
                }
                
            }else if Index == 2{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "membership", amount: 280, description: "Yearly", membershipType: 3, credits: 0)
                }
                
            }else if Index == 3{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "membership", amount: 500, description: "Lifetime", membershipType: 4, credits: 0)
                }
            }
        }else  if type == "applePay"{
            if Index == 0{
                
                self.setupApplePay(Description:"Weekly",amount:8)
                
                
            }else if Index == 1{
                
                self.setupApplePay(Description:"Monthly",amount:25)
                
                
            }else if Index == 2{
                
                self.setupApplePay(Description:"Yearly",amount:280)
                
                
            }else if Index == 3{
                
                self.setupApplePay(Description:"Lifetime",amount:500)
                
                
            }
        }else  if type == "Paypal"{
            if Index == 0{
                self.startCheckout(amount: 8, memberShipType: 1)
            }else if Index == 1{
                self.startCheckout(amount: 25, memberShipType: 2)
            }else if Index == 2{
                self.startCheckout(amount: 280, memberShipType: 3)
            }else if Index == 3{
                self.startCheckout(amount: 500, memberShipType: 4)
            }
            
        }
    }
    func setupApplePay(Description:String,amount:Int)
    {
        paymentRequest = PKPaymentRequest()
        paymentRequest.currencyCode = "USD"
        paymentRequest.countryCode = "US"
        paymentRequest.merchantIdentifier = "merchant.com.ScriptSun.QuickDateiOS.App"
        // Payment networks array
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        paymentRequest.supportedNetworks = paymentNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        let item = PKPaymentSummaryItem(label: "Order Total", amount: NSDecimalNumber(string: "\(amount)"))
        paymentRequest.paymentSummaryItems = [item]
        let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        applePayVC!.delegate = self
        self.present(applePayVC!, animated: true, completion: nil)
        //    if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks:paymentNetworks)
        //    {
        //
        //    }
        //    else
        //    {
        //    // Notify the user that he/she needs to set up the Apple Pay on the device
        //    // Below code calls a common function to display alert message. You can either create an alert or  can just print something on console.
        //    self.displayDefaultAlert(title: "Error", message: "Apple Pay is not available on this device.")
        //    print("Apple Pay is not available on this device")
        //    }
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension UpgradeAccountVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title:NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("The Apple Pay transaction was complete.", comment: "The Apple Pay transaction was complete."))
    }
}
extension UpgradeAccountVC:BTAppSwitchDelegate, BTViewControllerPresentingDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        self.showProgressDialog(text: "Loading...")
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        log.verbose("Switched")
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        self.dismissProgressDialog {
            log.verbose("Switched")
        }
    }
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
}
