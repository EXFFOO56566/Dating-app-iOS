

import Foundation
import Alamofire
import QuickdateSDK

class LikesManager {
    static let instance = LikesManager()
    
    func likesAdd(AccessToken:String,To_userId:Int,likeiD:Int? , disLikeiD:Int?, completionBlock: @escaping (_ Success:LikesModel.LikesSuccessModel?,_ SessionError:LikesModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.likes: likeiD,
             API.PARAMS.dislikes: disLikeiD,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_LIKES_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_LIKES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                log.verbose("Response = \(response.value)")
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LikesModel.LikesSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LikesModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func likeMatches(AccessToken:String,LikesIdString:String,DisLikesIdString:String, completionBlock: @escaping (_ Success:LikesModel.LikesSuccessModel?,_ SessionError:LikesModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.likes: LikesIdString,
//            API.PARAMS.dislikes: DisLikesIdString,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_LIKES_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_LIKES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
	                log.verbose("Response = \(response.value)")
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LikesModel.LikesSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LikesModel.sessionErrorModel.self, from: data!)
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

