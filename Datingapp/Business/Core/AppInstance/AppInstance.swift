

import Foundation
import Async
import UIKit
import QuickdateSDK
import JGProgressHUD

class AppInstance {
    
    // MARK: - Properties
    
    static let instance = AppInstance()
    
    var hud : JGProgressHUD?
    var userId:Int? = nil
    var accessToken:String? = nil
    var genderText:String? = "all"
    var profilePicText:String? = "all"
    var statusText:String? = "all"
    var playSongBool:Bool? = false
    var currentIndex:Int? = 0
    var popupPlayPauseSong:Bool? = false
    var offlinePlayPauseSong:Bool? = false
    var settings:GetSettingsModel.DataClass?
    var filterData:FilterModel?
     var addCount:Int? = 0
    var loction:String?
      var gender:String?
      var ageMin:Int?
      var ageMax:Int?
      var body:Int?
      var fromHeight:Int?
      var toHeight:Int?
      var language:Int?
      var religion:Int?
      var ethnicity:Int?
      var relationship:Int?
      var smoke:Int?
      var drink:Int?
      var interest:String?
      var education:Int?
      var pets:Int?
      var distance:Int?
      
    
    
    // MARK: -
    var userProfile:UserProfileModel.UserProfileSuccessModel?
    
    func showProgressDialog(text: String,view:UIView) {
           hud = JGProgressHUD(style: .dark)
           hud?.textLabel.text = text
        hud?.show(in: view)
       }
       
       func dismissProgressDialog(completionBlock: @escaping () ->()) {
           hud?.dismiss()
           completionBlock()
           
           
       }
    
    func getUserSession()->Bool{
        // Log
        log.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
        
        let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
        if localUserSessionData.isEmpty{
            return false
        }else {
            self.userId = (localUserSessionData[Local.USER_SESSION.User_id]  as! Int)
            self.accessToken = localUserSessionData[Local.USER_SESSION.Access_token] as? String ?? ""
            return true
        }
    }
    
    func fetchUserProfile(view:UIView,completionBlock: @escaping () ->()){
        
        let status = AppInstance.instance.getUserSession()
        if status{
            self.showProgressDialog(text: "Loading....", view: view)
            let userId = AppInstance.instance.userId ?? 0
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                ProfileManger.instance.getProfile(UserId: userId, AccessToken: accessToken, FetchString: "data,media,likes,blocks,payments,reports,visits", completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            AppInstance.instance.userProfile = success ?? nil
                            self.dismissProgressDialog {
                                completionBlock()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            self.dismissProgressDialog {
                                 completionBlock()
                            }
                        
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription ?? "")")
                           self.dismissProgressDialog {
                                completionBlock()
                           }
                        })
                    }
                })
            })
        }else {
            log.error(InterNetError)
        }
    }
    func getSettings(completionBlock: @escaping () ->()){
        let locale = Locale.preferredLanguages.first
        log.verbose("Language = \(locale)")
        let language = NSLocale.preferredLanguages[0]
        let languageDic = NSLocale.components(fromLocaleIdentifier: language) as NSDictionary
        let languageCode = languageDic.object(forKey: "kCFLocaleLanguageCodeKey") as! String
        Async.background({
            GetSettingsManager.instance.getSettings(language: language, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.settings = success?.data
                        let objectToEncode = success?.data
                       let  data = try? PropertyListEncoder().encode(objectToEncode)
                        UserDefaults.standard.setSettings(value: data!, ForKey: Local.SETTINGS.Settings)
//
                        completionBlock()
                    })
                }else if sessionError != nil{
                    Async.main({
                        
                        log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                    })
                    
                }else {
                    Async.main({
                        log.error("error = \(error?.localizedDescription ?? "")")
                    })
                }
            })
        })
        
    }
}

