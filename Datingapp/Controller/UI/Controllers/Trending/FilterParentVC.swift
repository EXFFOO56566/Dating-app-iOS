

import UIKit
import XLPagerTabStrip
import JGProgressHUD
import QuickdateSDK
import Async
class FilterParentVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var applyFilterBtn: UIButton!
    var hud : JGProgressHUD?
    var filterDelegate:FilterDelegate?
    
    override func viewDidLoad() {
        self.setupUI()
        super.viewDidLoad()
    }
    
    @IBAction func applyFilterPressed(_ sender: Any) {
        self.filter()
    }
    
    private func setupUI() {
        self.applyFilterBtn.setTitle(NSLocalizedString("Apply Filter", comment: "Apply Filter"), for: .normal)
        
        let color = UIColor.Main_StartColor
        let oldColor  = UIColor.hexStringToUIColor(hex: "505050")
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = color
        //        settings.style.buttonBarItemFont =  UIFont(name: "Poppins", size: 15)!
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = oldColor
            newCell?.label.textColor = color
            print("OldCell",oldCell)
            print("NewCell",newCell)
        }
    }
    
    private func filter(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            let location = AppInstance.instance.loction ?? ""
            let gender = AppInstance.instance.gender ?? ""
            let ageMin = AppInstance.instance.ageMin ?? 0
            let ageMax = AppInstance.instance.ageMax ?? 0
            let body = AppInstance.instance.body ?? 0
            let toHeight = AppInstance.instance.toHeight ?? 0
            let fromeheight = AppInstance.instance.fromHeight ?? 0
            let language = AppInstance.instance.language ?? 0
            let religion = AppInstance.instance.religion ?? 0
            let ethinicity = AppInstance.instance.ethnicity ?? 0
            let relationship = AppInstance.instance.relationship ?? 0
            let smoke = AppInstance.instance.smoke ?? 0
            let drink = AppInstance.instance.drink ?? 0
            let interest = AppInstance.instance.interest ?? ""
            let education = AppInstance.instance.education ?? 0
            let pet = AppInstance.instance.pets ?? 0
            let located = AppInstance.instance.distance ?? 0
            
            Async.background({
                SearchManager.instance.filter(AccessToken: accessToken, Limit: 20, Offset: 0, Location: location, Gender: gender, AgeMin: ageMin, AgeMax: ageMax, Body: body, toHeight: toHeight, fromHeight: fromeheight, language: language, religion: religion, Ethnicity: ethinicity, relaship: relationship, smoke: smoke, drink: drink, interest: interest, education: education, pet: pet,distance:located, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                self.dismiss(animated: true, completion: {
                                    self.filterDelegate?.filter(status: true, searchArray: success?.data ?? [])
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
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let filterVC = R.storyboard.trending.filterVC()
        let looksFilterVC = R.storyboard.trending.looksFilterVC()
        let backgroundFilterVC = R.storyboard.trending.backgroundFilterVC()
        let lifeStyleFilterVC = R.storyboard.trending.lifeStyleFilterVC()
        let moreFilterVC = R.storyboard.trending.moreFilterVC()
        
        return [filterVC!,looksFilterVC!,backgroundFilterVC!,lifeStyleFilterVC!,moreFilterVC!]
    }
}
