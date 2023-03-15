

import Foundation
import Alamofire
import QuickdateSDK

class OnlineSwitchManager{
    static let instance = OnlineSwitchManager()
    
    func getNotifications(AccessToken:String,status:Int, completionBlock: @escaping (_ Success:OnlineSwitchModel.OnlineSwitchSuccessModel?,_ SessionError:OnlineSwitchModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.online: status,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SWITCH_ONLINE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.SWITCH_ONLINE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(OnlineSwitchModel.OnlineSwitchSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(OnlineSwitchModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
