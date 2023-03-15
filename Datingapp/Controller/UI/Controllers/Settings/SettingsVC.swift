//
//  SettingsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class SettingsVC: BaseVC {
    
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.setupUI()
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI(){
        self.settingsLabel.text = NSLocalizedString("Settings", comment: "Settings")
        self.settingsTableView.separatorStyle = .none
        self.settingsTableView.register(R.nib.settingsSectionTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier)
        self.settingsTableView.register(R.nib.settingsSectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier)
        self.settingsTableView.register(R.nib.settingsSectionThreeTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier)
        
    }
    private func logoutUser(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                UserManager.instance.logout(AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                let vc = R.storyboard.authentication.main()
                                self.appDelegate.window?.rootViewController = vc
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
    func removeCache() {
        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
        do {
            try FileManager.default.removeItem(atPath: path)
            self.view.makeToast("Cache Cleared")
        } catch {
            print("ERROR DESCRIPTION: \(error)")
        }
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 1, section: 0) {
            return 56
        } else if indexPath == IndexPath(row: 0, section: 1) {
            return 95
        }
        else if indexPath.section == 4{
            return UITableView.automaticDimension
        }
        else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 { // my account
                let vc = R.storyboard.settings.myAccountVC()
                navigationController?.pushViewController(vc!, animated: true)
            }  else if indexPath.row == 1 { // social links
                let vc = R.storyboard.settings.socialLinkVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 2 {
                let vc = R.storyboard.settings.blockUserVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == 3 { // change password
                 let vc = R.storyboard.settings.withdrawalsVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
            else if indexPath.row == 4 { // change password
                let vc = R.storyboard.settings.myAffliatesVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{ // change password
           let vc = R.storyboard.settings.changePasswordVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else   if indexPath.row == 1{ // change password
                let vc = R.storyboard.settings.twoFactorUpdateVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
            else   if indexPath.row == 2{ // change password
                let vc = R.storyboard.settings.sessionsVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        }else if indexPath.section == 5{
            removeCache()
        }else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                let vc = R.storyboard.settings.helpVC()
                vc?.checkString = "help"
                self.navigationController?.pushViewController(vc!, animated: true)
            case 1:
                let vc = R.storyboard.settings.helpVC()
                vc?.checkString = "about"
                self.navigationController?.pushViewController(vc!, animated: true)
                print("About")
            case 2: // delete account
               let vc = R.storyboard.settings.deleteAccountVC()
               navigationController?.pushViewController(vc!, animated: true)
            case 3: // logout
                let alert = UIAlertController(title:NSLocalizedString("Logout", comment: "Logout") , message: NSLocalizedString("Are you sure you want to logout?", comment: "Are you sure you want to logout?"), preferredStyle: .alert)
                let comfirm = UIAlertAction(title:NSLocalizedString("confirm", comment: "confirm"), style: .default) { (action) in
                    self.logoutUser()
                    
                }
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: nil)
                alert.addAction(comfirm)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            view.backgroundColor = UIColor.systemBackground
            
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
            separatorView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
            
            let label = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.size.width, height: 48))
            label.textColor = UIColor.Main_StartColor
            label.font = UIFont(name: "Poppins-Regular", size: 17)
            if section == 0 {
                label.text = NSLocalizedString("General", comment: "General")
            } else if section == 1 {
                label.text = NSLocalizedString("Security", comment: "Security")
            }else if section == 2 {
                label.text = NSLocalizedString("Display", comment: "Display")
            }else if section == 3{
                label.text = NSLocalizedString("Messenger", comment: "Messenger")
            } else if section == 4 {
                label.text = NSLocalizedString("Privacy", comment: "Privacy")
            } else if section == 5 {
                label.text =  NSLocalizedString("Storage", comment: "Storage")
            } else {
                label.text = NSLocalizedString("Support", comment: "Support")
            }
            view.addSubview(separatorView)
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 56
        }
    }
}

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 5
        case 1: return 3
            case 2: return 1
        case 3: return 1
        case 4: return 3
        case 5: return 1
        case 6: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("My Account", comment: "My Account")
                return cell
                
            case 1:
               let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
               cell.titleLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
                return cell
            case 2:
                 let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Blocked Users", comment: "Blocked Users")
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Withdrawals", comment: "Withdrawals")
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("My Affliates", comment: "My Affliates")
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Password", comment: "Password")
                cell.subTitleLabel.text = NSLocalizedString("Change your password", comment: "Change your password")
                return cell
                case 1:
                 let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
                return cell
                
            case 2:
                 let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
                return cell
                
                
            default:
                return UITableViewCell()
            }
            case 2:
                       let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
                       cell.checkStringStatus = "DarkMode"
                       cell.titleLabel.text =  NSLocalizedString("Theme", comment: "Theme")

                       cell.config()
                       return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            cell.titleLabel.text =  NSLocalizedString("Show when you're active", comment: "Show when you're active")
            cell.checkStringStatus = "onlineSwitch"
            cell.switchDelegate = self
            return cell
        case 4:
           let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Show my profile on search engines?", comment: "Show my profile on search engines?")
                if AppInstance.instance.userProfile?.data?.privacyShowProfileOnGoogle == "0"{
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "searchEngine"
                cell.delegate = self
                cell.randomUser = AppInstance.instance.userProfile?.data?.privacyShowProfileRandomUsers ?? ""
                cell.matchProfile = AppInstance.instance.userProfile?.data?.privacyShowProfileMatchProfiles ?? ""
                cell.searchEngine = AppInstance.instance.userProfile?.data?.privacyShowProfileOnGoogle ?? ""
            case 1:
                cell.titleLabel.text = NSLocalizedString("Show my profile in random users?", comment: "Show my profile in random users?")
                if AppInstance.instance.userProfile?.data?.privacyShowProfileRandomUsers == "0"{
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "randomUser"
                cell.delegate = self
                cell.randomUser = AppInstance.instance.userProfile?.data?.privacyShowProfileRandomUsers ?? ""
                cell.matchProfile = AppInstance.instance.userProfile?.data?.privacyShowProfileMatchProfiles ?? ""
                cell.searchEngine = AppInstance.instance.userProfile?.data?.privacyShowProfileOnGoogle ?? ""
            case 2:
                cell.titleLabel.text =  NSLocalizedString("Show my profile in find match page?", comment: "Show my profile in find match page?")
                if AppInstance.instance.userProfile?.data?.privacyShowProfileMatchProfiles == "0"{
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "matchProfile"
                cell.delegate = self
                cell.randomUser = AppInstance.instance.userProfile?.data?.privacyShowProfileRandomUsers ?? ""
                cell.matchProfile = AppInstance.instance.userProfile?.data?.privacyShowProfileMatchProfiles ?? ""
                cell.searchEngine = AppInstance.instance.userProfile?.data?.privacyShowProfileOnGoogle ?? ""
            default:
                break
            }
            return cell
        case 5:
          let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            cell.titleLabel.text = NSLocalizedString("Clear Cache", comment: "Clear Cache")
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Help", comment: "Help")
            case 1:
                cell.titleLabel.text = NSLocalizedString("About", comment: "About")
            case 2:
                cell.titleLabel.text = NSLocalizedString("Delete account", comment: "Delete account")
            case 3:
                cell.titleLabel.text = NSLocalizedString("Logout", comment: "Logout")
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
extension SettingsVC:didUpdateSettingsDelegate{
    func updateSettings(searchEngine: Int, randomUser: Int, matchProfile: Int, switch: UISwitch) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                ProfileManger.instance.updateSettings(AccessToken: accessToken, searchEngine: searchEngine, randomUser: randomUser, matchPage: matchProfile, activeness: 1, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                     log.debug("UPDATED")
                                })
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            log.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
extension SettingsVC:didUpdateOnlineStatusDelegate{
    func updateOnlineStatus(status: Int, switch: UISwitch) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                OnlineSwitchManager.instance.getNotifications(AccessToken: accessToken, status: status, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                    log.verbose("UPdate")
                                })
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            log.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
