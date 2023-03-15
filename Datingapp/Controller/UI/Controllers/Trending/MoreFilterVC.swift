

import UIKit
import XLPagerTabStrip
class MoreFilterVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var eductionTextField: UITextField!
    @IBOutlet weak var petsTextField: UITextField!
    
    var interestStringIndex:String? = ""
    var educationStringIndex:String? = ""
    var petsStringIndex:String? = ""
    
    var interestStatus = false
    var educationStatus = false
    var petsStatus = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interestTextField.delegate = self
        self.setupUI()
    }
    private func setupUI(){
           self.interestTextField.placeholder = NSLocalizedString("Interest", comment: "Interest")
            self.eductionTextField.placeholder = NSLocalizedString("Education", comment: "Education")
            self.petsTextField.placeholder = NSLocalizedString("Pets", comment: "Pets")
       }
    @IBAction func educationPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Education"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func petsPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Pet"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppInstance.instance.interest = textField.text ?? ""
    }
}
extension MoreFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("MORE", comment: "MORE") )
    }
}
extension MoreFilterVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
         if Type == "Education"{
            self.eductionTextField.text = selectedString
            self.educationStringIndex = "\(index)"
            AppInstance.instance.education = index
         }else if Type == "Pet"{
            self.petsTextField.text = selectedString
            self.petsStringIndex = "\(index)"
            log.verbose(" self.petsStringIndex = \(petsStringIndex ?? "")")
            AppInstance.instance.pets = index
        }
    }
}
