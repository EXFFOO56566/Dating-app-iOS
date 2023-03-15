//
//  HotOrNotVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class HotOrNotVC: BaseVC {
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var hotNotLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImage: UIImageView!
    var hotOrNotArray:[HotOrNotModel.Datum] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
         self.noImage.tintColor = .Main_StartColor
        self.filterBtn.tintColor = .Button_StartColor
        self.hotNotLabel.text = NSLocalizedString("Hot or Not", comment: "Hot or Not")
        self.noLabel.text = NSLocalizedString("There is no data to show", comment: "There is no data to show")
        tableView.separatorStyle = .none
        tableView.register(R.nib.hotOrNotShowTableItem(), forCellReuseIdentifier: R.reuseIdentifier.hotOrNotShowTableItem.identifier)
        if self.hotOrNotArray.isEmpty{
            self.noImage.isHidden = false
            self.noImage.isHidden = false
        }else{
            self.noImage.isHidden = true
            self.noImage.isHidden = true
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("Gender", comment: "Gender"), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let male = UIAlertAction(title:NSLocalizedString("Male", comment: "Male") , style: .default) { (action) in
            let male = AppInstance.instance.settings?.gender![0]
            for i in male!.keys{
                self.fetchData(gender: i)
            }
        }
        let female = UIAlertAction(title:NSLocalizedString("Female", comment: "Female"), style: .default) { (action) in
            let female = AppInstance.instance.settings?.gender![1]
            for i in female!.keys{
                self.fetchData(gender: i)
            }
        }
        let defaultSelect = UIAlertAction(title: NSLocalizedString("Defualt", comment: "Defualt"), style: .default) { (action) in
            self.fetchData(gender: "")
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(defaultSelect)
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    private func fetchData(gender:String){
        if Connectivity.isConnectedToNetwork(){
            self.hotOrNotArray.removeAll()
            self.tableView.reloadData()
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                HotOrNotManager.instance.getHotOrNot(AccessToken: accessToken, limit: 20, offset: 0, genders: gender) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("userList = \(success?.data ?? [])")
                            self.hotOrNotArray = success?.data ?? []
                            
                            if self.hotOrNotArray.isEmpty{
                                self.noImage.isHidden = false
                                self.noImage.isHidden = false
                            }else{
                                self.noImage.isHidden = true
                                self.noImage.isHidden = true
                            }
                            self.tableView.reloadData()
                            
                            
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
                }
                
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    
//    private func blockUser(UserId:Int){
//        if Connectivity.isConnectedToNetwork(){
//            self.baseVC?.showProgressDialog(text: "Loading...")
//            let accessToken = AppInstance.instance.accessToken ?? ""
//            let toID = UserId
//            
//            Async.background({
//                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
//                    if success != nil{
//                        Async.main({
//                            self.baseVC?.dismissProgressDialog {
//                                
//                                log.debug("userList = \(success?.message ?? "")")
//                                self.vc?.view.makeToast(success?.message ?? "")
//                                self.vc?.navigationController?.popViewController(animated: true)
//                            }
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.baseVC?.dismissProgressDialog {
//                                
//                                self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
//                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                            }
//                        })
//                    }else {
//                        Async.main({
//                            self.baseVC?.dismissProgressDialog {
//                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
//                                log.error("error = \(error?.localizedDescription ?? "")")
//                            }
//                        })
//                    }
//                })
//            })
//            
//        }else{
//            log.error("internetError = \(InterNetError)")
//            self.vc?.view.makeToast(InterNetError)
//        }
//    }
    
    
}
extension HotOrNotVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotOrNotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.hotOrNotShowTableItem.identifier, for: indexPath) as? HotOrNotShowTableItem
        cell?.selectionStyle = .none
        let object = self.hotOrNotArray[indexPath.row]
        cell?.bind(object)
        cell?.hotOrNotVC = self
        cell?.indexPath = indexPath.row
        cell?.userID = object.id ?? 0
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userObject = hotOrNotArray[indexPath.row]
        let vc = R.storyboard.main.showUserDetailsVC()
        
        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText:userObject.countryText ??  "", relationshipText: userObject.relationshipText ??  "", bodyText: userObject.bodyText ??  "", smokeText: userObject.smokeText ?? "", ethnicityText:userObject.ethnicityText ?? "" , petsText:userObject.petsText ??  "", genderText:userObject.genderText ??  "", about: "", isFriend: false, isFavourite: false, is_friend_request: false)
        
//        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText:userObject.countryText ??  "", relationshipText: userObject.relationshipText ??  "", bodyText: userObject.bodyText ??  "", smokeText: userObject.smokeText ?? "", ethnicityText:userObject.ethnicityText ?? "" , petsText:userObject.petsText ??  "", genderText:userObject.genderText ??  "", about: "")
        
        vc?.object = object
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
}
