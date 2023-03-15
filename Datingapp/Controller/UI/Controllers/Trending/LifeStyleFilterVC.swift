

import UIKit
import XLPagerTabStrip
class LifeStyleFilterVC: UIViewController {

    @IBOutlet weak var drinkTextFIeld: UITextField!
    @IBOutlet weak var smokeTextField: UITextField!
    @IBOutlet weak var relationShipTextField: UITextField!
    
    
    var drinkStringIndex:String? = ""
    var smokeStringIndex:String? = ""
    var religionStringIndex:String? = ""
   
    
    
    var drinkStatus = false
    var smokeStatus = false
    var relationshipStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
              self.relationShipTextField.placeholder = NSLocalizedString("relationShipTextField", comment: "relationShipTextField")
               self.smokeTextField.placeholder = NSLocalizedString("smoke", comment: "smoke")
               self.drinkTextFIeld.placeholder = NSLocalizedString("Drink", comment: "Drink")
          }
    
    @IBAction func drinkPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Drink"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func smokePressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Smoke"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func relationShipPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Relationship"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    } 
}
extension LifeStyleFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("LIFESTYLE", comment: "LIFESTYLE"))
    }
}
extension LifeStyleFilterVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
         if Type == "Relationship"{
            self.relationShipTextField.text = selectedString
            self.religionStringIndex = "\(index)"
            AppInstance.instance.relationship = index
         }else if Type == "Smoke"{
            self.smokeTextField.text = selectedString
            self.smokeStringIndex = "\(index)"
            AppInstance.instance.smoke = index
         }else if Type == "Drink"{
            self.drinkTextFIeld.text = selectedString
            self.drinkStringIndex = "\(index)"
            AppInstance.instance.drink = index
        }
    }
    
    
    
    
}
