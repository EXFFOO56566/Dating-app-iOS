
import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds

class EditLooksVC: BaseVC,UITextFieldDelegate {
    
    
    @IBOutlet weak var editLooksInfoLabel: UILabel!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var ethnicityTextField: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    var ethnicityStringIndex:String? = ""
    var bodyStringIndex:String? = ""
    var heightStringIndex:String? = ""
    
    var ethnicityStatus = false
    var bodyStatus = false
    var heightStatus = false
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateLooks()
    }
    private func setupUI(){
         self.saveBtn.backgroundColor = .Button_StartColor
        if ControlSettings.shouldShowAddMobBanner{

                         bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                         addBannerViewToView(bannerView)
                         bannerView.adUnitID = ControlSettings.addUnitId
                         bannerView.rootViewController = self
                         bannerView.load(GADRequest())
                       
                     }
        self.editLooksInfoLabel.text = NSLocalizedString("Edit looks Info", comment: "Edit looks Info")
        self.ethnicityTextField.placeholder = NSLocalizedString("Ethnicity", comment: "Ethnicity")
          self.bodyTextField.placeholder = NSLocalizedString("Body", comment: "Body")
        self.heightTextField.placeholder = NSLocalizedString("Height", comment: "Height")
         self.colorTextField.placeholder = NSLocalizedString("Color", comment: "Color")
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        
        
        
        let userData =  AppInstance.instance.userProfile?.data
        self.colorTextField.text = userData?.colour ?? ""
        AppInstance.instance.settings?.ethnicity?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.ethnicity{
                    self.ethnicityTextField.text = it[it1]
                    ethnicityStatus = true
                    return
                }
                if ethnicityStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.body?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.body{
                    self.bodyTextField.text = it[it1]?.htmlAttributedString ?? ""
                    bodyStatus = true
                    return
                }
                if bodyStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.height?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.height{
                    self.heightTextField.text = it[it1]
                    heightStatus = true
                    return
                }
                if heightStatus {
                    return
                }
            })
        })
        
        
        self.ethnicityStringIndex = userData?.ethnicity
        self.bodyStringIndex = userData?.body
        self.heightStringIndex = userData?.height
        
        self.ethnicityTextField.delegate = self
        self.bodyTextField.delegate = self
        self.heightTextField.delegate = self
        
        ethnicityTextField.addTarget(self, action: #selector(ethnicityTapped), for: .allTouchEvents)
        bodyTextField.addTarget(self, action: #selector(bodyTapped), for: .touchUpInside)
        heightTextField.addTarget(self, action: #selector(heightTapped), for: .touchUpInside)
       
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
              bannerView.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(bannerView)
              view.addConstraints(
                  [NSLayoutConstraint(item: bannerView,
                                      attribute: .bottom,
                                      relatedBy: .equal,
                                      toItem: bottomLayoutGuide,
                                      attribute: .top,
                                      multiplier: 1,
                                      constant: 0),
                   NSLayoutConstraint(item: bannerView,
                                      attribute: .centerX,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: .centerX,
                                      multiplier: 1,
                                      constant: 0)
                  ])
          }
    @objc func ethnicityTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Ethnicity"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @objc func bodyTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Body"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func heightTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Height"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    private func updateLooks(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let color = self.colorTextField.text ?? ""
            let height = self.heightStringIndex ?? ""
            let body = self.bodyStringIndex ?? ""
            let ethnicity = self.ethnicityStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editLooks(AccessToken: accessToken, Color: color, Body: body, Height: height, Ethnicity: ethnicity, completionBlock: { (success, sessionError, error) in
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
    // MARK: - textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
extension EditLooksVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Ethnicity"{
            self.ethnicityTextField.text = selectedString
             self.ethnicityStringIndex = "\(index)"
        }else if Type == "Body"{
            self.bodyTextField.text = selectedString
            self.bodyStringIndex = "\(index)"
        }else if Type == "Height"{
            self.heightTextField.text = selectedString
            self.heightStringIndex = "\(index)"
        }
    }
    
}
