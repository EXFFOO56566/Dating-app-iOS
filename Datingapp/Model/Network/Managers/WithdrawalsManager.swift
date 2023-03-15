//
//  WithdrawalsManager.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire
import QuickdateSDK
class WithdrawalsManager{
    
    static let instance = WithdrawalsManager()
    
    func requestWithdrawals(AccessToken:
        String,amount:String,email:String,completionBlock: @escaping (_ Success:WithdrawalsModel.WithdrawalsSuccessModel?,_ sessionError:WithdrawalsModel.sessionErrorModel?, Error?) ->()){
        let params = [
            API.PARAMS.amount: amount,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.paypal_email: email,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.REQUEST_WITHDRAWAL_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.REQUEST_WITHDRAWAL_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(WithdrawalsModel.WithdrawalsSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(WithdrawalsModel.sessionErrorModel.self, from: data!)
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
