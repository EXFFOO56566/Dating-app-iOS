

import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds

class EditPersonalityVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var petTextFIeld: UITextField!
    @IBOutlet weak var friendsTextField: UITextField!
    @IBOutlet weak var childrenTextField: UITextField!
    @IBOutlet weak var characterTextIField: UITextField!
    
    var characterStringIndex:String? = ""
    var childrenStringIndex:String? = ""
    var friendsStringIndex:String? = ""
    var petStringIndex:String? = ""

    
    var characterShipStatus = false
    var childrenStatus = false
    var friendStatus = false
    var petStatus = false
     var bannerView: GADBannerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updatePersonality()
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
        self.personalInfoLabel.text = NSLocalizedString("Personality Info", comment: "Personality Info")
        self.characterTextIField.placeholder = NSLocalizedString("Character", comment: "Character")
        self.childrenTextField.placeholder = NSLocalizedString("Children", comment: "Children")
        self.friendsTextField.placeholder = NSLocalizedString("Friends", comment: "Friends")
        self.petTextFIeld.placeholder = NSLocalizedString("Pet", comment: "Pet")
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        let userData =  AppInstance.instance.userProfile?.data
    
        
        AppInstance.instance.settings?.character?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.character{
                    self.characterTextIField.text = it[it1]
                    characterShipStatus = true
                    return
                }
                if characterShipStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.children?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.children{
                    self.childrenTextField.text = it[it1]?.htmlAttributedString ?? ""
                    childrenStatus = true
                    return
                }
                if childrenStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.friends?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.friends{
                    self.friendsTextField.text = it[it1]
                    friendStatus = true
                    return
                }
                if friendStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.pets?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.pets{
                    self.petTextFIeld.text = it[it1]
                    petStatus = true
                    return
                }
                if petStatus {
                    return
                }
            })
        })
        
        
        self.characterStringIndex = userData?.character
        self.childrenStringIndex = userData?.children
        self.friendsStringIndex = userData?.friends
        self.petStringIndex = userData?.pets
        
        self.characterTextIField.delegate = self
        self.childrenTextField.delegate = self
        self.friendsTextField.delegate = self
        self.petTextFIeld.delegate = self
        
        characterTextIField.addTarget(self, action: #selector(characterTapped), for: .allTouchEvents)
        childrenTextField.addTarget(self, action: #selector(childrenTapped), for: .touchUpInside)
        friendsTextField.addTarget(self, action: #selector(friendTapped), for: .touchUpInside)
        petTextFIeld.addTarget(self, action: #selector(petTapped), for: .touchUpInside)
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
    @objc func characterTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Character"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
      
    }
    @objc func childrenTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Children"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func friendTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Friends"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func petTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Pet"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    private func updatePersonality(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let pet  = self.petStringIndex ?? ""
            let friend = self.friendsStringIndex ?? ""
            let children = self.childrenStringIndex ?? ""
            let character = self.characterStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editPersonality(AccessToken: accessToken, Character: character, Children: children, Friends: friend, Pet: pet, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                    log.verbose("UPDATED")
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}
extension EditPersonalityVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Character"{
            self.characterTextIField.text = selectedString
            self.characterStringIndex = "\(index)"
        }else if Type == "Children"{
            self.childrenTextField.text = selectedString
            self.childrenStringIndex = "\(index)"
        }else if Type == "Friends"{
            self.friendsTextField.text = selectedString
            self.friendsStringIndex = "\(index)"
        }else if Type == "Pet"{
            self.petTextFIeld.text = selectedString
            self.petStringIndex = "\(index)"
        }
        
    }
    
    
    
    
}
