

import UIKit

class SelectGenderVC: UIViewController {
    var delegate : selectGenderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func femalePressed(_ sender: Any) {
        self.dismiss(animated: true) {
              self.delegate?.selectGender(type: "female", TypeID: AppInstance.instance.settings?.gender![1], status: true)
        }
    }
    @IBAction func malePressed(_ sender: Any) {
        self.dismiss(animated: true) {
                     self.delegate?.selectGender(type: "female", TypeID: AppInstance.instance.settings?.gender![0], status: true)
               }
        
    }
    @IBAction func defaultPressed(_ sender: Any) {
        self.dismiss(animated: true) {
                     self.delegate?.selectGender(type: "default", TypeID: nil, status: nil)
               }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
