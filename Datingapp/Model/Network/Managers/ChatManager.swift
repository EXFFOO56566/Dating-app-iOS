
import Foundation
import Alamofire
import QuickdateSDK
class ChatManager{
    static let instance = ChatManager()
    
    func getConversation(AccessToken:String,Limit:Int,Offset:Int, completionBlock: @escaping (_ Success:GetConversationModel.GetConversationSuccessModel?,_ SessionError:GetConversationModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.limit: Limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.offset: Offset
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.GET_CONVERSATION_LIST_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.GET_CONVERSATION_LIST_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GetConversationModel.GetConversationSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetConversationModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func getChatConversation(AccessToken:String,To_userId:Int,Limit:Int,Offset:Int, completionBlock: @escaping (_ Success:GetChatConversationModel.GetChatConversationSuccessModel?,_ SessionError:GetChatConversationModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.limit: Limit,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.to_userid: To_userId,
            API.PARAMS.offset: Offset
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.GET_CHAT_CONVERSATIONS_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.GET_CHAT_CONVERSATIONS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GetChatConversationModel.GetChatConversationSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GetChatConversationModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func clearChat(AccessToken:String,To_userId:Int, completionBlock: @escaping (_ Success:ClearChatModel.ClearChatSuccessModel?,_ SessionError:ClearChatModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
             API.PARAMS.to_userid: To_userId,
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.DELETE_MESSAGES_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.DELETE_MESSAGES_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ClearChatModel.ClearChatSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ClearChatModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func sendMessage(AccessToken:String,To_userId:Int,Message:String,Hash_Id:Int, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ SessionError:SendMessageModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: To_userId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.message: Message,
            API.PARAMS.hash_id: Hash_Id
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.SEND_MESSAGE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("Message response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SendMessageModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func sendSticker(AccessToken:
        String,To_userId:Int,StickerId:Int,Hash_Id:Int, completionBlock: @escaping (_ Success:sendStickerModel.sendStickerSuccessModel?,_ SessionError:sendStickerModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: To_userId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.sticker_id: StickerId,
            API.PARAMS.hash_id: Hash_Id
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.MESSAGE_CONSTANT_METHODS.SEND_STICKER_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.MESSAGE_CONSTANT_METHODS.SEND_STICKER_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("Message response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(sendStickerModel.sendStickerSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(sendStickerModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func sendGift(AccessToken:
        String,To_userId:Int,GiftId:Int,Hash_Id:Int, completionBlock: @escaping (_ Success:sendGiftModel.sendGiftSuccessModel?,_ SessionError:sendGiftModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: To_userId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.gift_id: GiftId,
            API.PARAMS.hash_id: Hash_Id
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.SEND_GIFT_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.SEND_GIFT_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("Message response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(sendGiftModel.sendGiftSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(sendGiftModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func sendMedia(AccessToken:
        String,To_userId:Int,Hash_Id:Int,MediaData:Data?, completionBlock: @escaping (_ Success:SendMediaModel.SendMediaSuccessModel?,_ sessionError:SendMediaModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.to_userid: To_userId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.hash_id: Hash_Id
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let avatarData = MediaData{
                multipartFormData.append(avatarData, withName: "media_file", fileName: "m.jpg", mimeType: "image/png")
            }
            
        }, to: API.MESSAGE_CONSTANT_METHODS.SEND_MEDIA_API, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
            print("Succesfully uploaded")
            log.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(SendMediaModel.SendMediaSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(SendMediaModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
               
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
