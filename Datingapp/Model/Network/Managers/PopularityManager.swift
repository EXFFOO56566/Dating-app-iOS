

import Foundation
import Alamofire
import QuickdateSDK

class PopularityManager{
    static let instance = PopularityManager()
    
    func managePopularity(AccessToken:String,Type:String, completionBlock: @escaping (_ Success:PopularityModel.PopularitySuccessModel?,_ SessionError:PopularityModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.type: Type,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.MANAGE_POPULARITY_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.MANAGE_POPULARITY_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                 let apiStatus = res["status"]  as? Int
                 let apiCode = res["code"]  as? Int
                if apiStatus ==  API.ERROR_CODES.E_200 || apiCode == API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(PopularityModel.PopularitySuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400 || apiCode == API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(PopularityModel.sessionErrorModel.self, from: data!)
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
