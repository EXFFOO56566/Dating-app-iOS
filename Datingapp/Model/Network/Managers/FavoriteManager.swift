//
//  FavoriteManager.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/21/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickdateSDK
class FavoriteManager{
    
    static let instance = FavoriteManager()
    
    func fetchFavorite(AccessToken:
        String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:FetchFavoriteModel.FetchFavoriteSuccessModel?,_ sessionError:FetchFavoriteModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.limit: limit,
            API.PARAMS.offset: offset,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.FETCH_FAVORITE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.FETCH_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(FetchFavoriteModel.FetchFavoriteSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(FetchFavoriteModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func addFavorite(AccessToken:
        String,uid:Int, completionBlock: @escaping (_ Success:AddFavoriteModel.AddFavoriteSuccessModel?,_ sessionError:AddFavoriteModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.uid: uid,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.ADD_FAVORITE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.ADD_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode == nil{
                    let apiCode = res["code"]  as? Int
                    if apiCode ==  API.ERROR_CODES.E_200 {
                        log.verbose("apiStatus Int = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                        let result = try? JSONDecoder().decode(AddFavoriteModel.AddFavoriteSuccessModel.self, from: data!)
                        completionBlock(result,nil,nil)
                    }else if apiCode ==  API.ERROR_CODES.E_400{
                        log.verbose("apiStatus String = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                        let result = try? JSONDecoder().decode(AddFavoriteModel.sessionErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors?.errorText ?? "")")
                        completionBlock(nil,result,nil)
                    }
                }else{
                    if apiCode ==  API.ERROR_CODES.E_200 {
                        log.verbose("apiStatus Int = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                        let result = try? JSONDecoder().decode(AddFavoriteModel.AddFavoriteSuccessModel.self, from: data!)
                        completionBlock(result,nil,nil)
                    }else if apiCode ==  API.ERROR_CODES.E_400{
                        log.verbose("apiStatus String = \(apiCode)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                        let result = try? JSONDecoder().decode(AddFavoriteModel.sessionErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors?.errorText ?? "")")
                        completionBlock(nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteFavorite(AccessToken:
        String,uid:Int, completionBlock: @escaping (_ Success:AddFavoriteModel.AddFavoriteSuccessModel?,_ sessionError:AddFavoriteModel.sessionErrorModel?, Error?) ->()){
        let params = [
            
            API.PARAMS.uid: uid,
            API.PARAMS.access_token: AccessToken,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.FAVORITE_CONSTANT_METHODS.DELETE_FAVORITE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.FAVORITE_CONSTANT_METHODS.DELETE_FAVORITE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["status"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(AddFavoriteModel.AddFavoriteSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(AddFavoriteModel.sessionErrorModel.self, from: data!)
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

