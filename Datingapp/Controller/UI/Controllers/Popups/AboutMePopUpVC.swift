

import UIKit
import Async
import QuickdateSDK
protocol ReloadTableViewDataDelegate {
    func reloadTableView(Status:Bool)
}
class AboutMePopUpVC: BaseVC {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutMetextFIeld: CustomTextField!
    var delegate:ReloadTableViewDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        updateAboutMe()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        self.aboutLabel.textColor = .Main_StartColor
        self.cancelBtn.setTitleColor(.Main_StartColor, for: .normal)
         self.submitBtn.setTitleColor(.Main_StartColor, for: .normal)
        self.aboutMetextFIeld.lineColor = .Main_StartColor
        self.aboutLabel.text = NSLocalizedString("About", comment: "About")
        self.aboutMetextFIeld.placeholder =  NSLocalizedString("About me", comment: "About me")
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit"), for: .normal)
        let userData =  AppInstance.instance.userProfile?.data
        self.aboutMetextFIeld.text = userData?.about ?? ""
    }
    private func updateAboutMe(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let aboutMeString = self.aboutMetextFIeld.text ?? ""
            
            Async.background({
                ProfileManger.instance.updateAboutMe(AccessToken: accessToken, AboutMeText: aboutMeString, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                  
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
