//
//  HotOrNotManager.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickdateSDK
class HotOrNotManager{
    
    static let instance = HotOrNotManager()
    
    func getHotOrNot(AccessToken:
        String,limit:Int,offset:Int, genders:String,completionBlock: @escaping (_ Success:HotOrNotModel.HotOrNotSuccessModel?,_ sessionError:HotOrNotModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.offset: offset,
            API.PARAMS.limit: limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.genders: genders,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.HOT_OR_NOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(HotOrNotModel.HotOrNotSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(HotOrNotModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func addHot(AccessToken:
        String,userId:Int,completionBlock: @escaping (_ Success:AddHotOrNotModel.AddHotOrNotSuccessModel?,_ sessionError:AddHotOrNotModel.sessionErrorModel?, Error?) ->()){
           let params = [
               API.PARAMS.user_id: userId,
               API.PARAMS.access_token: AccessToken,
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
           log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_HOT_API)")
           log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_HOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   let apiCode = res["status"]  as? Int
                   if apiCode ==  API.ERROR_CODES.E_200 {
                       log.verbose("apiStatus Int = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AddHotOrNotModel.AddHotOrNotSuccessModel.self, from: data!)
                       completionBlock(result,nil,nil)
                   }else if apiCode ==  API.ERROR_CODES.E_400{
                       log.verbose("apiStatus String = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                       let result = try? JSONDecoder().decode(AddHotOrNotModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                       completionBlock(nil,result,nil)
                   }
               }else{
                   log.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    func addNot(AccessToken:
           String,userId:Int,completionBlock: @escaping (_ Success:AddHotOrNotModel.AddHotOrNotSuccessModel?,_ sessionError:AddHotOrNotModel.sessionErrorModel?, Error?) ->()){
              let params = [
                  API.PARAMS.user_id: userId,
                  API.PARAMS.access_token: AccessToken,
                  
                  ] as [String : Any]
              
              let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
              log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.ADD_NOT_API)")
              log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.ADD_NOT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
                  
                  if (response.value != nil){
                      guard let res = response.value as? [String:Any] else {return}
                      let apiCode = res["status"]  as? Int
                      if apiCode ==  API.ERROR_CODES.E_200 {
                          log.verbose("apiStatus Int = \(apiCode)")
                          let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                       let result = try? JSONDecoder().decode(AddHotOrNotModel.AddHotOrNotSuccessModel.self, from: data!)
                          completionBlock(result,nil,nil)
                      }else if apiCode ==  API.ERROR_CODES.E_400{
                          log.verbose("apiStatus String = \(apiCode)")
                          let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                          let result = try? JSONDecoder().decode(AddHotOrNotModel.sessionErrorModel.self, from: data!)
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

