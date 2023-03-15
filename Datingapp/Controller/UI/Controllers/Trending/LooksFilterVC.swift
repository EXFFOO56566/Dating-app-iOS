
import UIKit
import XLPagerTabStrip
class LooksFilterVC: BaseVC,UITextFieldDelegate {

    @IBOutlet weak var toHeightTextFIeld: UITextField!
    @IBOutlet weak var fromHeightTextFIeld: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    var fromHeightStringIndex:String? = ""
    var bodyStringIndex:String? = ""
    var toHeightStringIndex:String? = ""
    
    var fromHeightStatus = false
    var bodyStatus = false
    var toHeightStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

    }
    private func setupUI(){
        self.bodyTextField.placeholder = NSLocalizedString("Body", comment: "Body")
         self.fromHeightTextFIeld.placeholder = NSLocalizedString("From Height", comment: "Body")
         self.toHeightTextFIeld.placeholder = NSLocalizedString("To Height", comment: "To Height")
    }
    
    @IBAction func toHeightPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "toHeight"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func fromHeight(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "fromHeight"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func bodyPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Body"
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @objc func fromHeightTapped(textField: UITextField) {
     
    }
    @objc func bodyTapped(textField: UITextField) {
       
        
    }
    @objc func toHeightTapped(textField: UITextField) {
       
        
    }
    // MARK: - textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
extension LooksFilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("LOOKS", comment: "LOOKS"))
    }
}
extension LooksFilterVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "fromHeight"{
            self.fromHeightTextFIeld.text = selectedString
            self.fromHeightStringIndex = "\(index)"
            AppInstance.instance.fromHeight = index
        }else if Type == "Body"{
            self.bodyTextField.text = selectedString
            self.bodyStringIndex = "\(index)"
            AppInstance.instance.body = index
        }else if Type == "toHeight"{
            self.toHeightTextFIeld.text = selectedString
            self.toHeightStringIndex = "\(index)"
            AppInstance.instance.toHeight = index
        }
    }
    
}
