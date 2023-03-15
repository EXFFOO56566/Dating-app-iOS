

import Foundation
import Alamofire
import QuickdateSDK
class BlockUserManager {
     static let instance = BlockUserManager()
    
    func blockUser(AccessToken:String,To_userId:Int, completionBlock: @escaping (_ Success:BlockUserModel.BlockUserSuccessModel?,_ SessionError:BlockUserModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.block_userid: To_userId,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.BLOCK_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.BLOCK_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(BlockUserModel.BlockUserSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(BlockUserModel.sessionErrorModel.self, from: data!)
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
