
import UIKit
import QuickdateSDK
import PassKit
import Async

struct dataSet{
    var title:String?
    var bgColor:UIColor?
    var bgImage:UIImage?
}
struct dataSetTwo{
    var title:String?
    var Credit:String?
    var itemImage:UIImage?
    var ammount:String?
}

class BuyCreditVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    let product_id: NSString = "com.some.inappid"
    var index = 0
    var dataSetArray = [dataSet]()
    var delegate:movetoPayScreenDelegate?
    var paymentRequest: PKPaymentRequest!
    var transactionId = ""
    var status = ""
    var amount = 100
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    private func setupUI(){
        self.tableView.separatorStyle = .none
        self.tableView.register(R.nib.buyCreditSectionTableItem(), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionTableItem.identifier)
        self.tableView.register(R.nib.buyCreditSectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoTableItem.identifier)
        self.tableView.register(R.nib.buyCreditSectionThreeTableItem(), forCellReuseIdentifier: R.reuseIdentifier.buyCreditSectionThreeTableItem.identifier)
        
    }
    
    override func viewWillLayoutSubviews() {
        //        self.topView.halfCircleView()
    }
    
    @IBAction func termConditionPressed(_ sender: Any) {
        
    }
    @IBAction func skipCreditPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func startCheckout(amount:Int,credit:Int) {
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
                
                
                self.setCredit(through: "paypal", amount: amount, credit: credit)
                
            } else if let error = error {
                log.verbose("error = \(error.localizedDescription ?? "")")
            } else {
                log.verbose("error = \(error?.localizedDescription ?? "")")
            }
        }
    }
    private func setCredit(through:String,amount:Int,credit:Int){
        
        self.showProgressDialog(text: "Loading...")
        
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let amountInt = amount ?? 0
            let creditInt = credit ?? 0
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
}


extension BuyCreditVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:return 1
        case 1:return 1
        case 2:return 1
        default: return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionTableItem.identifier) as? BuyCreditSectionTableItem
            cell?.selectionStyle = .none
            
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionTwoTableItem.identifier) as? BuyCreditSectionTwoTableItem
            cell?.selectionStyle = .none
            cell?.vc = self
            cell?.paymentDelegate = self
            
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.buyCreditSectionThreeTableItem.identifier) as? BuyCreditSectionThreeTableItem
            cell?.selectionStyle = .none
            cell?.vc = self
            
            return cell!
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 300
        case 2:
            return 150
        default:
            return 300
        }
    }
}
extension BuyCreditVC:didSelectPaymentDelegate{
    func selectPayment(status: Bool, type: String, Index: Int,PaypalCredit:Int?) {
        
        if type == "creditCard"{
            if Index == 0{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 50, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 1000)
                }
                
            }else if Index == 1{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 100, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 5000)
                }
                
            }else if Index == 2{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 150, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 10000)
                }
            }
            
        }else  if type == "bankTransfer"{
            if Index == 0{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "credits", amount: 50, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 1000)
                }
                
            }else if Index == 1{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "credits", amount: 100, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 5000)
                }
                
            }else if Index == 2{
                self.dismiss(animated: true) {
                    self.delegate?.moveToPayScreen(status: false, payType: "credits", amount: 150, description: dataSetTwoArray[Index].title ?? "", membershipType: 0, credits: 10000)
                }
            }
            
        }else  if type == "applePay"{
            A4WPurchaseManager.buyProVersion { (success) in
                    
                        log.verbose("Purchased = \(success)")
//                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didPurchasePRO"), object: nil)
//                         self.didPurchaseProduct?(success)
                     
                 }
           
            //            if Index == 0{
            //                self.setupApplePay(Description:self.dataSetTwoArray[Index].title ?? "",amount:50)
            //            }else if Index == 1{
            //                self.setupApplePay(Description:self.dataSetTwoArray[Index].title ?? "",amount:100)
            //
            //            }else if Index == 2{
            //                self.setupApplePay(Description:self.dataSetTwoArray[Index].title ?? "",amount:150)
            //
            //            }
        }else  if type == "Paypal"{
            if Index == 0{
                self.startCheckout(amount: 50, credit: 1000)
            }else if Index == 1{
                self.startCheckout(amount: 100, credit: 5000)
            }else if Index == 2{
                self.startCheckout(amount: 150, credit: 10000)
            }
            
        }
    }
    //    func setupApplePay(Description:String,amount:Int)
    //    {
    //        paymentRequest = PKPaymentRequest()
    //        paymentRequest.currencyCode = "USD"
    //        paymentRequest.countryCode = "US"
    //        paymentRequest.merchantIdentifier = "merchant.com.ScriptSun.QuickDateiOS.App"
    //        // Payment networks array
    //        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
    //        paymentRequest.supportedNetworks = paymentNetworks
    //        paymentRequest.merchantCapabilities = .capability3DS
    //        let item = PKPaymentSummaryItem(label: "Order Total", amount: NSDecimalNumber(string: "\(amount)"))
    //        paymentRequest.paymentSummaryItems = [item]
    //        let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
    //        applePayVC!.delegate = self
    //        self.present(applePayVC!, animated: true, completion: nil)
    //        //    if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks:paymentNetworks)
    //        //    {
    //        //
    //        //    }
    //        //    else
    //        //    {
    //        //    // Notify the user that he/she needs to set up the Apple Pay on the device
    //        //    // Below code calls a common function to display alert message. You can either create an alert or  can just print something on console.
    //        //    self.displayDefaultAlert(title: "Error", message: "Apple Pay is not available on this device.")
    //        //    print("Apple Pay is not available on this device")
    //        //    }
    //    }
    
}
//extension BuyCreditVC: PKPaymentAuthorizationViewControllerDelegate {
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        dismiss(animated: true, completion: nil)
//
//    }
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        dismiss(animated: true, completion: nil)
//        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
//    }
//}

extension BuyCreditVC:BTAppSwitchDelegate, BTViewControllerPresentingDelegate{
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
