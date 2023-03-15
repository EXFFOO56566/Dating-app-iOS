
import UIKit
import Async
import QuickdateSDK
class UnblockUserPopUpVC: BaseVC {

    var UserID:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func yesPressed(_ sender: Any) {
        self.unBlockUser()
    }
    
    @IBAction func noPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func unBlockUser(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = Int(self.UserID ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
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

