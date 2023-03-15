//
//  LikeDislikeMananger.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation

import Alamofire
import QuickdateSDK
class LikeDislikeMananger{
    
    static let instance = LikeDislikeMananger()
    
    func getLikePeople(AccessToken:
        String,limit:Int,offset:Int,completionBlock: @escaping (_ Success:LikeDislikeModel.LikeDislikeSuccessModel?,_ sessionError:LikeDislikeModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.LIST_LIKED_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.LIST_LIKED_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeModel.LikeDislikeSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func getDislikePeople(AccessToken:
           String,limit:Int,offset:Int,completionBlock: @escaping (_ Success:LikeDislikeModel.LikeDislikeSuccessModel?,_ sessionError:LikeDislikeModel.sessionErrorModel?, Error?) ->()){
           let params = [
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.limit: limit,
               API.PARAMS.offset: offset,
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
           let decoded = String(data: jsonData!, encoding: .utf8)!
           log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.LIST_DISLIKED_API)")
           log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.LIST_LIKED_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   let apiCode = res["status"]  as? Int
                   if apiCode ==  API.ERROR_CODES.E_200 {
                       log.verbose("apiStatus Int = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeModel.LikeDislikeSuccessModel.self, from: data!)
                       completionBlock(result,nil,nil)
                   }else if apiCode ==  API.ERROR_CODES.E_400{
                       log.verbose("apiStatus String = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                       completionBlock(nil,result,nil)
                   }
               }else{
                   log.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
    func deleteLike(AccessToken:
        String,id:Int,completionBlock: @escaping (_ Success:LikeDislikeDeleteModel.LikeDislikeDeleteSuccessModel?,_ sessionError:LikeDislikeDeleteModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.user_likeid: id,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.DELETE_LIKE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.DELETE_LIKE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeDeleteModel.LikeDislikeDeleteSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(LikeDislikeDeleteModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteDislike(AccessToken:
           String,id:Int,completionBlock: @escaping (_ Success:LikeDislikeDeleteModel.LikeDislikeDeleteSuccessModel?,_ sessionError:LikeDislikeDeleteModel.sessionErrorModel?, Error?) ->()){
           let params = [
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.user_dislike: id,
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
           log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.DELETE_DISLIKE_API)")
           log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.DELETE_DISLIKE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   let apiCode = res["code"]  as? Int
                   if apiCode ==  API.ERROR_CODES.E_200 {
                       log.verbose("apiStatus Int = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                       let result = try? JSONDecoder().decode(LikeDislikeDeleteModel.LikeDislikeDeleteSuccessModel.self, from: data!)
                       completionBlock(result,nil,nil)
                   }else if apiCode ==  API.ERROR_CODES.E_400{
                       log.verbose("apiStatus String = \(apiCode)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                       let result = try? JSONDecoder().decode(LikeDislikeDeleteModel.sessionErrorModel.self, from: data!)
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
