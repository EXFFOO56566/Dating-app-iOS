
import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds

class EditLifeStyleVC: BaseVC,UITextFieldDelegate {

    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var travelTextField: UITextField!
    @IBOutlet weak var drinkTextFIeld: UITextField!
    @IBOutlet weak var smokeTextField: UITextField!
    @IBOutlet weak var religionTextField: UITextField!
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var iLiveInTextField: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    var liveWithStringIndex:String? = ""
    var carStringIndex:String? = ""
    var religionStringIndex:String? = ""
    var smokeStringIndex:String? = ""
    var drinkStringIndex:String? = ""
    var travelStringIndex:String? = ""
    
    
    var liveWithShipStatus = false
    var carStatus = false
    var religionStatus = false
    var smokeStatus = false
    var drinkStatus = false
    var travelStatus = false
     var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

    }
    

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateLifeStyle()
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
        self.lifeStyleLabel.toolbarPlaceholder = NSLocalizedString("Life Style Info", comment: "Life Style Info")
        self.iLiveInTextField.placeholder = NSLocalizedString("I live With", comment: "I live With")
          self.carTextField.placeholder = NSLocalizedString("Car", comment: "Car")
          self.religionTextField.placeholder = NSLocalizedString("Religion", comment: "Religion")
        self.smokeTextField.placeholder = NSLocalizedString("smoke", comment: "smoke")
        self.drinkTextFIeld.placeholder = NSLocalizedString("Drink", comment: "Drink")
          self.travelTextField.placeholder = NSLocalizedString("Travel", comment: "Travel")
        
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        let userData =  AppInstance.instance.userProfile?.data
        AppInstance.instance.settings?.liveWith?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.liveWith{
                    self.iLiveInTextField.text = it[it1]
                    liveWithShipStatus = true
                    return
                }
                if liveWithShipStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.car?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.car{
                    self.carTextField.text = it[it1]?.htmlAttributedString ?? ""
                    carStatus = true
                    return
                }
                if carStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.religion?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.religion{
                    self.religionTextField.text = it[it1]
                    religionStatus = true
                    return
                }
                if religionStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.smoke?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.smoke{
                    self.smokeTextField.text = it[it1]
                    smokeStatus = true
                    return
                }
                if smokeStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.drink?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.drink{
                    self.drinkTextFIeld.text = it[it1]
                    drinkStatus = true
                    return
                }
                if drinkStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.travel?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.travel{
                    self.travelTextField.text = it[it1]
                    travelStatus = true
                    return
                }
                if travelStatus {
                    return
                }
            })
        })
        
        
        self.liveWithStringIndex = userData?.liveWith
        self.carStringIndex = userData?.car
        self.religionStringIndex = userData?.religion
        self.smokeStringIndex = userData?.smoke
        self.drinkStringIndex = userData?.drink
        self.travelStringIndex = userData?.travel
        
        self.iLiveInTextField.delegate = self
        self.carTextField.delegate = self
        self.religionTextField.delegate = self
        self.smokeTextField.delegate = self
        self.drinkTextFIeld.delegate = self
        self.travelTextField.delegate = self
        
        iLiveInTextField.addTarget(self, action: #selector(liveWithTapped), for: .allTouchEvents)
        carTextField.addTarget(self, action: #selector(carTapped), for: .touchUpInside)
        religionTextField.addTarget(self, action: #selector(religionTapped), for: .touchUpInside)
        smokeTextField.addTarget(self, action: #selector(smokeTapped), for: .touchUpInside)
          drinkTextFIeld.addTarget(self, action: #selector(drinkTapped), for: .touchUpInside)
        travelTextField.addTarget(self, action: #selector(travelTapped), for: .touchUpInside)
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
    @objc func liveWithTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Live With"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @objc func carTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Car"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func religionTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Religion"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func smokeTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Smoke"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func drinkTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Drink"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func travelTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Travel"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    private func updateLifeStyle(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let travel  = self.travelStringIndex ?? ""
            let drink = self.drinkStringIndex ?? ""
            let smoke = self.smokeStringIndex ?? ""
            let religion = self.religionStringIndex ?? ""
            let car = self.carStringIndex ?? ""
            let liveIn = self.liveWithStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editLifeStyle(AccessToken: accessToken, Livewith: liveIn, Car: car, Religion: religion, smoke: smoke, Drink: drink, Travel: travel, completionBlock: { (success, sessionError, error) in
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
extension EditLifeStyleVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Live With"{
            self.iLiveInTextField.text = selectedString
            self.liveWithStringIndex = "\(index)"
        }else if Type == "Car"{
            self.carTextField.text = selectedString
            self.carStringIndex = "\(index)"
        }else if Type == "Religion"{
            self.religionTextField.text = selectedString
            self.religionStringIndex = "\(index)"
        }else if Type == "Smoke"{
            self.smokeTextField.text = selectedString
            self.smokeStringIndex = "\(index)"
        }else if Type == "Drink"{
            self.drinkTextFIeld.text = selectedString
            self.drinkStringIndex = "\(index)"
        }else if Type == "Travel"{
            self.travelTextField.text = selectedString
            self.travelStringIndex = "\(index)"
        }
    }
    
    
    
    
}
