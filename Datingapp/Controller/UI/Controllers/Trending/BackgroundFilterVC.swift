

import UIKit
import XLPagerTabStrip


class BackgroundFilterVC: UIViewController {
    
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var religionTextField: UITextField!
    @IBOutlet weak var ethnicityTextField: UITextField!
    
    var ethnicityStringIndex:String? = ""
    var languageStringIndex:String? = ""
    var religionStringIndex:String? = ""
    
    var ethnicityStatus = false
    var religionStatus = false
    var languageStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
                self.languageTextField.placeholder = NSLocalizedString("Language", comment: "Language")
                 self.religionTextField.placeholder = NSLocalizedString("Religion", comment: "Religion")
                 self.ethnicityTextField.placeholder = NSLocalizedString("Ethnicity", comment: "Ethnicity")
            }
    
    @IBAction func ethnicityPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Ethnicity"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func languagePressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Language"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func religionPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Religion"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
}

extension BackgroundFilterVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Ethnicity"{
            self.ethnicityTextField.text = selectedString
            self.ethnicityStringIndex = "\(index)"
            AppInstance.instance.ethnicity = index
        }else if Type == "Religion"{
            self.religionTextField.text = selectedString
            self.religionStringIndex = "\(index)"
             AppInstance.instance.religion = index
        }else if Type == "Language"{
            self.languageTextField.text = selectedString
            self.languageStringIndex = "\(index)"
            AppInstance.instance.language = index
        }
    }
    
}
extension BackgroundFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("BACKGROUND", comment: "BACKGROUND"))
    }
}
