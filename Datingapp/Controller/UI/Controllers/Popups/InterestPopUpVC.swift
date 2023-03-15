

import UIKit
import Async
import QuickdateSDK
class InterestPopUpVC: BaseVC {
    
    var delegate:ReloadTableViewDataDelegate?

    
    @IBOutlet weak var interestTextField: CustomTextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var interestLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        self.updateInterest()
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    private func setupUI(){
        self.interestLabel.textColor = .Main_StartColor
               self.cancelBtn.setTitleColor(.Main_StartColor, for: .normal)
                self.submitBtn.setTitleColor(.Main_StartColor, for: .normal)
               self.interestTextField.lineColor = .Main_StartColor
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
         self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit"), for: .normal)
        interestTextField.placeholder = NSLocalizedString("Interest", comment: "Interest")
        self.interestLabel.text = NSLocalizedString("Interest", comment: "Interest")
        let userData =  AppInstance.instance.userProfile?.data
        self.interestTextField.text = userData?.interest ?? ""
    }
    private func updateInterest(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let interestString = self.interestTextField.text ?? ""
            
            Async.background({
                ProfileManger.instance.updateInterest(AccessToken: accessToken, InterestText: interestString, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                     log.debug("UPDATED")
                                    self.dismiss(animated: true) {
                                                                         self.delegate?.reloadTableView(Status: true)
                                                                     }
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
    
    
}
