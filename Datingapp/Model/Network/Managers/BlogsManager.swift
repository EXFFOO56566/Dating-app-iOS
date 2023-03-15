
import Foundation
import Alamofire
import QuickdateSDK

class BlogsManager{
    static let instance = BlogsManager()
    
    func getBlogs(AccessToken:String,limit:Int,offset:Int, completionBlock: @escaping (_ Success:BlogsModel.BlogsSuccessModel?,_ SessionError:BlogsModel	.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.limit: limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.offset: offset
      
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.BLOGS_CONSTANT_METHODS.ARTICLES_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.BLOGS_CONSTANT_METHODS.ARTICLES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    log.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(BlogsModel.BlogsSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(BlogsModel.sessionErrorModel.self, from: data!)
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

