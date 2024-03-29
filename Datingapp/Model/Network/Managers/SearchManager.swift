

import Foundation
import Alamofire
import QuickdateSDK
class SearchManager {
    static let instance = SearchManager()
    
    func Search(AccessToken:String,Limit:Int,Offset:Int, completionBlock: @escaping (_ Success:SearchModel.SearchSuccessModel?,_ SessionError:SearchModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            API.PARAMS.limit: Limit,
            API.PARAMS.offset: Offset,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.SEARCH_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.SEARCH_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SearchModel.SearchSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SearchModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func filter(AccessToken:String,Limit:Int,Offset:Int,Location:String,Gender:String,AgeMin:Int,AgeMax:Int,Body:Int,toHeight:Int,fromHeight:Int,language:Int,religion:Int,Ethnicity:Int,relaship:Int,smoke:Int,drink:Int,interest:String,education:Int,pet:Int,distance:Int, completionBlock: @escaping (_ Success:SearchModel.SearchSuccessModel?,_ SessionError:SearchModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.limit: Limit,
            API.PARAMS.offset: Offset,
            API.PARAMS.location0: Location,
            API.PARAMS.gender0: Gender,
            API.PARAMS.age_to0: AgeMin,
            API.PARAMS.age_from0: AgeMax,
            API.PARAMS.body0: Body,
            API.PARAMS.height_from0: fromHeight,
            API.PARAMS.height_to0: toHeight,
            API.PARAMS.language0: language,
            API.PARAMS.religion0: religion,
            API.PARAMS.ethnicity0: Ethnicity,
            API.PARAMS.smoke0: smoke,
            API.PARAMS.drink0: drink,
            API.PARAMS.interest0: interest,
            API.PARAMS.education0: education,
            API.PARAMS.relationship0: relaship,
            API.PARAMS.pets0: pet,
             API.PARAMS.located0 : pet,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.SEARCH_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.SEARCH_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SearchModel.SearchSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SearchModel.sessionErrorModel.self, from: data!)
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
