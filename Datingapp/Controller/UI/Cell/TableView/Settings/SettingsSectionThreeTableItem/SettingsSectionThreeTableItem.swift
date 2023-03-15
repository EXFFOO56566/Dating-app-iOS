//
//  SettingsSectionThreeTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK

class SettingsSectionThreeTableItem: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var switcher: UISwitch!
    
    var searchEngine:String? = ""
    var randomUser:String? = ""
    var matchProfile:String? = ""
    var switchStatusValue:Bool? = false
    var delegate:didUpdateSettingsDelegate?
     var switchDelegate:didUpdateOnlineStatusDelegate?
    var checkStringStatus:String? = ""
    var switchStatus:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switcher.onTintColor = .Main_StartColor
        self.switcher.thumbTintColor = .Main_EndColor
//        if checkStringStatus == "searchEngine"{
//
//            if searchEngine == "0"{
//                switchStatusValue = false
//            }else {
//                switchStatusValue = true
//            }
//
//        }else if checkStringStatus == "randomUser"{
//            if randomUser == "0"{
//                switchStatusValue = false
//
//            }else {
//                switchStatusValue = true
//
//            }
//        }else if checkStringStatus == "matchProfile"{
//
//
//
//            if matchProfile == "0"{
//                switchStatusValue = false
//
//            }else {
//                switchStatusValue = true
//
//            }
//        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(){
           let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
           if status{
               self.switcher.setOn(true, animated: true)
           }else{
               self.switcher.setOn(false, animated: true)
           }
       }

    @IBAction func switchPressed(_ sender: Any) {
        if checkStringStatus == "searchEngine"{
//            switchStatusValue = !switchStatusValue!
            if switchStatusValue!{
                let searchEngineValueInt = 0
                let randomUserValueInt = Int(self.randomUser ?? "")
                let matchProfileValueInt = Int(self.matchProfile ?? "")
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt!, matchProfile: matchProfileValueInt!, switch: switcher)
            }else{
                let searchEngineValueInt = 1
                let randomUserValueInt = Int(self.randomUser ?? "")
                let matchProfileValueInt = Int(self.matchProfile ?? "")
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt, randomUser: randomUserValueInt!, matchProfile: matchProfileValueInt!, switch: switcher)
            }
        }else if checkStringStatus == "randomUser"{
//            switchStatusValue = !switchStatusValue!
            if switchStatusValue!{
                let searchEngineValueInt = Int(self.searchEngine ?? "")
                let randomUserValueInt = 0
                let matchProfileValueInt = Int(self.matchProfile ?? "")
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt!, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt!, switch: switcher)
            }else{
                let searchEngineValueInt = Int(self.searchEngine ?? "")
                let randomUserValueInt = 1
                let matchProfileValueInt = Int(self.matchProfile ?? "")
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt!, randomUser: randomUserValueInt, matchProfile: matchProfileValueInt!, switch: switcher)
            }
        }else if checkStringStatus == "matchProfile"{
//            switchStatusValue = !switchStatusValue!
            if switchStatusValue!{
                let searchEngineValueInt = Int(self.searchEngine ?? "")
                let randomUserValueInt = Int(self.randomUser ?? "")
                let matchProfileValueInt = 0
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt!, randomUser: randomUserValueInt!, matchProfile: matchProfileValueInt, switch: switcher)
            }else{
                let searchEngineValueInt = Int(self.searchEngine ?? "")
                let randomUserValueInt = Int(self.randomUser ?? "")
                let matchProfileValueInt = 1
                self.delegate?.updateSettings(searchEngine: searchEngineValueInt!, randomUser: randomUserValueInt!, matchProfile: matchProfileValueInt, switch: switcher)
            }
        }else if checkStringStatus == "onlineSwitch"{
            if switcher.isOn{
                self.switchStatus = 1
                self.switchDelegate?.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switcher)
            }else{
                  self.switchStatus = 0
                 self.switchDelegate?.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switcher)
            }
        }else if checkStringStatus == "DarkMode" {
            if #available(iOS 13.0, *) {
                if self.switcher.isOn{
                    window?.overrideUserInterfaceStyle = .dark
                    UserDefaults.standard.setDarkMode(value: true, ForKey: "darkMode")

                }else{
                    window?.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.setDarkMode(value: false, ForKey: "darkMode")

                }
            }
        }
    }
}

