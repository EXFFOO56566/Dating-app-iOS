

import Foundation
import Alamofire
import QuickdateSDK
class UserManager{
    static let instance = UserManager()
    
    func authenticateUser(UserName: String, Password: String,Platform:String,DeviceId:String, completionBlock: @escaping (_ Success:LoginModel.LoginSuccessModel?,_ TwoFactorVerifyModel:TwoFactorVerifyModel.TwoFactorVerifySuccessModel?,_ SessionError:LoginModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.username: UserName,
            API.PARAMS.password: Password,
            API.PARAMS.platform: Platform,
            API.PARAMS.device_id : DeviceId
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.LOGIN_API)")
        log.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.LOGIN_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                guard let message = res["message"] as? String else
                {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    if message == "Please enter your confirmation code"{
                        log.verbose("apiStatus Int = \(apiStatus)")
                                              let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                                              
                        let result = try? JSONDecoder().decode(TwoFactorVerifyModel.TwoFactorVerifySuccessModel.self, from: data!)
                        log.debug("Success = \(result?.message ?? "")")
                                        
                                              completionBlock(nil,result,nil,nil)
                    }else{
                        log.verbose("apiStatus Int = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                        
                        let result = try? JSONDecoder().decode(LoginModel.LoginSuccessModel.self, from: data!)
                        log.debug("Success = \(result?.message ?? "")")
                        let User_Session = [Local.USER_SESSION.Access_token:result?.data?.accessToken ?? "",Local.USER_SESSION.User_id:result?.data?.userID ?? 0] as! [String : Any]
                        UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                        completionBlock(result,nil,nil ,nil)
                    }
                    
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,nil,response.error)
            }
        }
    }
    func registerUser(FirstName:String,LastName:String,Email:String,UserName: String, Password: String,DeviceId:String,completionBlock: @escaping (_ Success:RegisterModel.RegisterSuccessModel?,_ SessionError:RegisterModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.first_name: FirstName,
            API.PARAMS.last_name:LastName ,
            API.PARAMS.email: Email,
            API.PARAMS.username: UserName,
            API.PARAMS.password: Password,
            API.PARAMS.device_id : "dwefhewufhsdklfhiosdfdsifhjdklsfj"]
//            API.PARAMS.device_id : DeviceId
        
        print(params)
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.REGISTER_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.REGISTER_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            print(response.value)
            log.verbose("Response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
//                    let data = try! JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = RegisterModel.RegisterSuccessModel.init(json: res)
                    print(result)
//                    let result = try! JSONDecoder().decode(RegisterModel.RegisterSuccessModel.self, from: data)
                   var accessToken = ""
                    var userId = 0
                    if let dataa = res["data"] as? [String:Any]{
                        if let token = dataa["access_token"] as? String{
                            accessToken = token
                        }
                        if let id = dataa["user_id"] as? Int{
                            userId = id
                        }
                    }
                    log.debug("Success = \(accessToken),,\(userId)")
                    let User_Session = [Local.USER_SESSION.Access_token:accessToken as Any,Local.USER_SESSION.User_id:userId as Any] as [String : Any]
                    UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                    completionBlock(result,nil,nil)
                }else{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(RegisterModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func forgetPassword(Email:String, completionBlock: @escaping (_ Success:ForgetPasswordModel.ForgetPasswordSuccessModel?,_ SessionError:ForgetPasswordModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.email: Email,
            
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.RESET_PASSWORD_API)")
        log.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.RESET_PASSWORD_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ForgetPasswordModel.ForgetPasswordSuccessModel.self, from: data!)
                    log.debug("Success = \(result)")
                    
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ForgetPasswordModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func logout(AccessToken:String, completionBlock: @escaping (_ Success:LogoutModel.LogoutSuccessModel?,_ SessionError:LogoutModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.LOGOUT_API)")
        log.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.LOGOUT_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LogoutModel.LogoutSuccessModel.self, from: data!)
                    log.debug("Success = \(result)")
                    
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LogoutModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func deleteAccount(AccessToken:String,Password:String, completionBlock: @escaping (_ Success:DeleteAccountModel.DeleteAccountSuccessModel?,_ SessionError:DeleteAccountModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.password: Password,
            
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.DELETE_ACCOUNT_API)")
        log.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.DELETE_ACCOUNT_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(DeleteAccountModel.DeleteAccountSuccessModel.self, from: data!)
                    log.debug("Success = \(result)")
                    
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(DeleteAccountModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func socialLogin(accessToken: String, Provider: String,DeviceId:String,googleApiKey:String ,completionBlock: @escaping (_ Success:LoginModel.LoginSuccessModel?,_ SessionError:LoginModel.sessionErrorModel?, Error?) ->()){
        var params = [String:String]()
               if Provider == API.SOCIAL_PROVIDERS.FACEBOOK{
                   params = [
                       API.PARAMS.provider: Provider,
                       API.PARAMS.access_token: accessToken,
                   ]
               }else{
                   params = [
                       API.PARAMS.provider: Provider,
                       API.PARAMS.access_token: accessToken,
//                       API.PARAMS.Google_Key : googleApiKey
                       ] as! [String : String]
               }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API)")
        log.verbose("Decoded String = \(decoded)")
        
        AF.request(API.AUTH_CONSTANT_METHODS.SOCIAL_LOGIN_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.LoginSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.message ?? "")")
                    let User_Session = [Local.USER_SESSION.Access_token:result?.data?.accessToken ?? "",Local.USER_SESSION.User_id:result?.data?.userID ?? 0] as! [String : Any]
                    UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func verifyTwoFactor( userId: Int,code:Int,completionBlock: @escaping (_ Success:LoginModel.LoginSuccessModel?,_ SessionError:LoginModel.sessionErrorModel?, Error?) ->()){
           let params = [
               
               API.PARAMS.code: code,
               API.PARAMS.user_id:userId
            ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
           let decoded = String(data: jsonData!, encoding: .utf8)!
           log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.VERIFY_TWO_FACTOR_API)")
           log.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.VERIFY_TWO_FACTOR_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
               log.verbose("Response = \(response.value)")
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   log.verbose("Response = \(res)")
                   guard let apiStatus = res["code"]  as? Int else {return}
                   if apiStatus ==  API.ERROR_CODES.E_200{
                       log.verbose("apiStatus Int = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LoginModel.LoginSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.data?.accessToken ?? "")")
                    let User_Session = [Local.USER_SESSION.Access_token:result?.data?.accessToken as Any,Local.USER_SESSION.User_id:result?.data?.userID as Any] as [String : Any]
                       UserDefaults.standard.setUserSession(value: User_Session, ForKey: Local.USER_SESSION.User_Session)
                       completionBlock(result,nil,nil)
                   }else{
                       log.verbose("apiStatus String = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                       let result = try? JSONDecoder().decode(LoginModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                       completionBlock(nil,result,nil)
                   }
               }else{
                   log.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    func loginWithWoWonder(userName : String, password : String, completionBlock : @escaping (_ Success:LoginWithWoWonderModel.LoginWithWoWonderSuccessModel?, _ AuthError : LoginWithWoWonderModel.LoginWithWoWonderErrorModel?, Error?)->()) {
        
        let params  = [
            API.PARAMS.ServerKey : ControlSettings.wowonder_ServerKey,
            API.PARAMS.username : userName,
            API.PARAMS.password :password
        ]
        
        AF.request("\(ControlSettings.wowonder_URL)api/auth", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"]  as? Any else {return}
                let apiCode = apiStatusCode as? Int
                if apiCode == 200 {
                    guard let allData = try? JSONSerialization.data(withJSONObject: response.value, options: [])else {return}
                    guard let result = try? JSONDecoder().decode(LoginWithWoWonderModel.LoginWithWoWonderSuccessModel.self, from: allData) else {return}
                    completionBlock(result,nil,nil)
                    
                }
                    
                else {
                    guard let allData = try? JSONSerialization.data(withJSONObject: response.value, options: [])else {return}
                    guard let result = try? JSONDecoder().decode(LoginWithWoWonderModel.LoginWithWoWonderErrorModel.self, from: allData) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
