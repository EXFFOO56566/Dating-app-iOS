

import UIKit
import QuickdateSDK
import Async
class EditProfileVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var genderLAbel: UILabel!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var relationshipTextFIeld: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var workStatusTextIFled: UITextField!
    @IBOutlet weak var languageTextFIeld: UITextField!
    @IBOutlet weak var locationTextField: UITextView!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var lastNameTextFIeld: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    var relationStipStringIndex:String? = ""
    var workstatusStringIndex:String? = ""
    var educationStringIndex:String? = ""
    
    var checkRelationShipStatus = false
    var checkWorkStatus = false
    var checkEducationStatus = false
    private var genderString:String? = ""
     let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.showDatePicker()
    }
    
    
    private func setupUI(){
        self.saveBtn.backgroundColor = .Button_StartColor
        self.editProfileLabel.text = NSLocalizedString("Edit Profile Info", comment: "Edit Profile Info")
        self.genderLAbel.text = NSLocalizedString("Gender", comment: "Gender")
        self.maleLabel.text = NSLocalizedString("Male", comment: "Male")
        self.femaleLabel.text = NSLocalizedString("Female", comment: "Female")
        
        self.birthdayTextField.placeholder = NSLocalizedString("Birthday", comment: "Birthday")
        self.languageTextFIeld.placeholder = NSLocalizedString("Language", comment: "Language")
        self.relationshipTextFIeld.placeholder = NSLocalizedString("Relationship", comment: "Relationship")
        self.workStatusTextIFled.placeholder = NSLocalizedString("Work status", comment: "Work status")
        self.educationTextField.placeholder = NSLocalizedString("Education", comment: "Education")
        
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        
        
        let userData =  AppInstance.instance.userProfile?.data
        
        self.firstNameTextField.text = userData?.firstName ?? ""
        self.lastNameTextFIeld.text = userData?.lastName ?? ""
        self.birthdayTextField.text = userData?.birthday ?? ""
        self.locationTextField.text = userData?.location ?? ""
        self.languageTextFIeld.text = userData?.language ?? ""
        
        if userData?.gender == "Male"{
            self.maleBtn.setImage(R.image.ic_radioOn(), for: .normal)
            self.genderString = "Male"
        }else{
            self.femaleBtn.setImage(R.image.ic_radioOn(), for: .normal)
            self.genderString = "Female"
        }
        AppInstance.instance.settings?.relationship?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.relationship{
                    self.relationshipTextFIeld.text = it[it1]
                    checkRelationShipStatus = true
                    return
                }
                if checkRelationShipStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.workStatus?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.workStatus{
                    self.workStatusTextIFled.text = it[it1]?.htmlAttributedString ?? ""
                    checkWorkStatus = true
                    return
                }
                if checkWorkStatus {
                    return
                }
            })
        })
        AppInstance.instance.settings?.education?.forEach({ (it) in
            it.keys.forEach({ (it1) in
                if it1 == userData?.education{
                    self.educationTextField.text = it[it1]
                    checkEducationStatus = true
                    return
                }
                if checkEducationStatus {
                    return
                }
            })
        })
        
        
        self.relationStipStringIndex = userData?.relationship
        self.workstatusStringIndex = userData?.workStatus
        self.educationStringIndex = userData?.education
        
        self.languageTextFIeld.delegate = self
        self.relationshipTextFIeld.delegate = self
        self.educationTextField.delegate = self
        self.workStatusTextIFled.delegate = self
        languageTextFIeld.addTarget(self, action: #selector(languageTapped), for: .allTouchEvents)
        relationshipTextFIeld.addTarget(self, action: #selector(relationShipTapped), for: .touchUpInside)
        workStatusTextIFled.addTarget(self, action: #selector(workStatusTapped), for: .touchUpInside)
        educationTextField.addTarget(self, action: #selector(EducationTapped), for: .touchUpInside)
        
        
    }
      func showDatePicker(){
       //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
      

       //done button & cancel button
        let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

    // add toolbar to textField
    birthdayTextField.inputAccessoryView = toolbar
     // add datepicker to textField
    birthdayTextField.inputView = datePicker

       }
    @objc func donedatePicker(){
     //For date formate
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy"
      birthdayTextField.text = formatter.string(from: datePicker.date)
      //dismiss date picker dialog
      self.view.endEditing(true)
       }

    @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
         
      
    @objc func languageTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Language"
        vc?.delegate = self
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    @objc func relationShipTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Relationship"
        vc?.delegate = self
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func workStatusTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Work Status"
        vc?.delegate = self
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    @objc func EducationTapped(textField: UITextField) {
        let vc = R.storyboard.popUps.profileEditPopUpVC()
        vc?.type = "Education"
        vc?.delegate = self
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func malePressed(_ sender: Any) {
        self.maleBtn.setImage(R.image.ic_radioOn(), for: .normal)
        self.femaleBtn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "Male"
    }
    
    @IBAction func femalePressed(_ sender: Any) {
        self.femaleBtn.setImage(R.image.ic_radioOn(), for: .normal)
        self.maleBtn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "Female"
    }
    @IBAction func savePressed(_ sender: Any) {
        updateProfile()
    }
    private func updateProfile(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let firstname = self.firstNameTextField.text ?? ""
            let lastname = self.lastNameTextFIeld.text ?? ""
            let genderString = self.genderString ?? ""
            let birthdayString = self.birthdayTextField.text ?? ""
            let location = self.locationTextField.text ?? ""
            let language = self.languageTextFIeld.text ??  ""
            let relationshipStatus = self.relationStipStringIndex ?? ""
            let workStatus = self.workstatusStringIndex ?? ""
            let education = self.educationStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editProfile(AccessToken: accessToken, Firstname: firstname, LastName: lastname, Gender: genderString, Birthday: birthdayString, Location: location, language: language, RelationShip: relationshipStatus, workStatus: workStatus, Education: education, completionBlock: { (success, sessionError, error) in
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
    // MARK: - textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
extension EditProfileVC:didSetProfilesParamDelegate{
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Language"{
            self.languageTextFIeld.text = selectedString
        }else if Type == "Relationship"{
            self.relationshipTextFIeld.text = selectedString
            self.relationStipStringIndex = "\(index)"
        }else if Type == "Work Status"{
            self.workStatusTextIFled.text = selectedString
            self.workstatusStringIndex = "\(index)"
        }else if Type == "Education"{
            self.educationTextField.text = selectedString
            self.educationStringIndex = "\(index)"
        }
        
        
        
    }
    
    
    
    
}
