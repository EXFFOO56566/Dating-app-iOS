//
//  LoginWithWoWonderModel.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 8/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
class LoginWithWoWonderModel {
    
    struct LoginWithWoWonderSuccessModel : Codable {
        let apiStatus: Int
        let timezone:String? = nil
        let accessToken:String?
        let userID: String?
        let message:String?
        
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case timezone
            case message
            case accessToken = "access_token"
            case userID = "user_id"
        }
    }
    
    
    struct LoginWithWoWonderErrorModel: Codable {
        let apiStatus: String
        let errors: Errors
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case errors
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID: Int
        let errorText: String
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
