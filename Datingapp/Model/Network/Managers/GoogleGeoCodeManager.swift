//
//  GoogleGeoCodeManager.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation
import Alamofire

class GoogleGeoCodeManager{

    func geoCode(address : String, completionBlock : @escaping (_ Success: GoogleGeoCodeModal.GoogleGeoCode_SuccessModal?, _ AuthError : GoogleGeoCodeModal.GoogleGeoCodeErrorModel? , Error?)->()){
//        AIzaSyCdzU_y3YKo12pjsa3HBSCwqeLjbqf4zjc
    let params = ["address" : address,"key":"AIzaSyAhreHQzmrv5tCGMgw4CGTMayusmUlbAaI"] as [String : Any]
//        https://maps.googleapis.com/maps/api/geocode/json
//        APIClient.GoogleMap.googleMapApi
        AF.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"]  as? Any else {return}
                let apiCodeString = apiStatusCode as? String
                
                if apiCodeString == "OK" {
                    guard let alldata = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    //                    print(response.value)
                    guard let result = try? JSONDecoder().decode(GoogleGeoCodeModal.GoogleGeoCode_SuccessModal.self, from: alldata) else {return}
                    //                    print(result)
                    completionBlock(result,nil,nil)
                    
                }
                    
                else if apiCodeString == "INVALID_REQUEST" {
                    let alldata = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(GoogleGeoCodeModal.GoogleGeoCodeErrorModel.self, from: alldata!)
                    completionBlock(nil,result,nil)
                    print(result)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    static let sharedInstance = GoogleGeoCodeManager()
    private init() {}
}
