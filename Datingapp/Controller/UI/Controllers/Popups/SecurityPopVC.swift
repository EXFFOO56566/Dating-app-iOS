

import UIKit
import SwiftEventBus
import QuickdateSDK
class SecurityPopVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorTextLabel: UILabel!
    
    var errorText:String? = ""
    var titleText:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    private func setupUI(){
        self.titleLabel.text =  NSLocalizedString(titleText ?? "Security", comment: titleText ?? "Security")
        self.errorTextLabel.text = NSLocalizedString(errorText ?? "", comment: errorText ?? "")
    }
    @IBAction func okPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
