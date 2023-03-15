

import UIKit
import Alamofire
import Async
import QuickdateSDK
import BraintreeDropIn
import Braintree
import Stripe
class PayVC: BaseVC,UITextFieldDelegate  {
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!

    @IBOutlet weak var continueLabel: UIButton!
    var payType:String? = ""
    var Description:String? = ""
    var amount:Int? = 0
    var memberShipType:Int? = 0
    var credits:Int? = 0
    var paymentType:String? = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yearTextField.delegate = self
        self.setupUI()
    }
    private func setupUI(){
        self.cardView.setGradientBackground(colorOne: .Main_StartColor, colorTwo: .Main_EndColor, horizontal: true)
        self.continueLabel.backgroundColor = .Button_StartColor
        self.creditLabel.text = NSLocalizedString("Credit Card", comment: "Credit Card")
        self.cardNumberTextField.placeholder =  NSLocalizedString("Enter your card number", comment: "Enter your card number")
        self.yearTextField.placeholder = NSLocalizedString("MMYY", comment: "MMYY")
        cvvTextField.text = NSLocalizedString("CVV", comment: "CVV")
        continueLabel.setTitle(NSLocalizedString("Continue", comment: "Continue"), for: .normal)
    }
    @IBAction func continuePressed(_ sender: Any) {
        self.getStipeToken()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(hide: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    private func getStipeToken(){
        self.showProgressDialog(text: "Loading...")
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = self.cardNumberTextField.text
        let expiryParameters = yearTextField.text?.components(separatedBy: "/")
        stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
        stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
        stripeCardParams.cvc = cvvTextField.text
        let config = STPPaymentConfiguration.shared()
        let stpApiClient = STPAPIClient.init(configuration: config)
        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
            if error == nil {
                Async.main({
                    log.verbose("Token = \(token?.tokenId)")
                    self.payStipe(stripeToken: token?.tokenId ?? "")
                })
            } else {
                self.dismissProgressDialog {
                    self.view.makeToast(error?.localizedDescription ?? "")
                    log.verbose("Error = \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    private func payStipe(stripeToken:String){
//        tok_visa
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let payTypeString = self.payType ?? ""
            let descriptionString = self.Description ?? ""
            let amountInt = self.amount ?? 0
            self.paymentType = "stripe"
            Async.background({
                PayStripeManager.instance.payStripe(AccessToken: accessToken, StripeToken: "tok_visa", Paytype: payTypeString, Description: descriptionString, Price: amountInt, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            if payTypeString == "membership"{
                                self.setPro(through: "stripe")
                            }else{
                                self.setCredit(through: "stripe")
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
    private func setPro(through:String){
        if paymentType == "paypal"{
            self.showProgressDialog(text: "Loading...")
        }
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let amountInt = self.amount ?? 0
            let membershipTypeInt = self.memberShipType ?? 0
            
            Async.background({
                SetProManager.instance.setPro(AccessToken: accessToken, Type: membershipTypeInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                                
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
    private func setCredit(through:String){
        if paymentType == "paypal"{
            self.showProgressDialog(text: "Loading...")
        }
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let amountInt = self.amount ?? 0
            let creditInt = self.credits ?? 0
            Async.background({
                SetCreditManager.instance.setPro(AccessToken: accessToken, Credits: creditInt, Price: amountInt, Via: through, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
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
    
  
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let currentText = textField.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        textField.text = updatedText
        let numberOfCharacters = updatedText.count
        if numberOfCharacters == 2 {
            textField.text?.append("/")
        }
        return false
    }
}



