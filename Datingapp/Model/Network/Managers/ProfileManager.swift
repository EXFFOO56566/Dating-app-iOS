

import Foundation
import Alamofire
import QuickdateSDK
class ProfileManger{
    
    
    static let instance = ProfileManger()
    
    func getProfile(UserId:Int,AccessToken:String,FetchString:String, completionBlock: @escaping (_ Success:UserProfileModel.UserProfileSuccessModel?,_ SessionError:UserProfileModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.fetch: FetchString
            
            ] as [String : Any]
        
        print(params)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.UserProfileSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateAccount(AccessToken:String, username: String, email: String, phone: String, country: String, completionBlock: @escaping (_ Success:UpdateAccountModel.UpdateAccountSuccessModel?,_ SessionError:UpdateAccountModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.username: username,
            API.PARAMS.email: email,
            API.PARAMS.phone_number: phone,
            API.PARAMS.country: country
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateAccountModel.UpdateAccountSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateAccountModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func changePassoword(AccessToken:String, currentPwd: String, newPwd: String, repeatNewPwd: String, completionBlock: @escaping (_ Success:ChangePasswordModel.ChangePasswordSuccessModel?,_ SessionError:ChangePasswordModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.c_pass: currentPwd,
            API.PARAMS.n_pass: newPwd,
            API.PARAMS.cn_pass: repeatNewPwd
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.CHANGE_PASSWORD_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.CHANGE_PASSWORD_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(ChangePasswordModel.ChangePasswordSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(ChangePasswordModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateSocialLinks(AccessToken:String,  facebook: String, twitter: String, google: String, instagram: String, linkedIn: String, website: String, completionBlock: @escaping (_ Success:UpdateSocialAccountsModel.UpdateSocialAccountsSuccessModel?,_ SessionError:UpdateSocialAccountsModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.facebook: facebook,
            API.PARAMS.twitter: twitter,
            API.PARAMS.google: google,
            API.PARAMS.instagram: instagram,
            API.PARAMS.linkedin: linkedIn,
            API.PARAMS.website: website
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateSocialAccountsModel.UpdateSocialAccountsSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateSocialAccountsModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateSettings(AccessToken:String,  searchEngine: Int, randomUser: Int, matchPage: Int, activeness: Int, completionBlock: @escaping (_ Success:UpdateSettingsModel.UpdateSettingsSuccessModel?,_ SessionError:UpdateSettingsModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.privacy_show_profile_on_google: searchEngine,
            API.PARAMS.privacy_show_profile_random_users: randomUser,
            API.PARAMS.privacy_show_profile_match_profiles: matchPage
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateSettingsModel.UpdateSettingsSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateSettingsModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editProfile(AccessToken:String,Firstname:String,LastName:String,Gender:String,Birthday:String,Location:String,language:String,RelationShip:String,workStatus:String,Education:String, completionBlock: @escaping (_ Success:EditProfileModel.EditProfileSuccessModel?,_ SessionError:EditProfileModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.first_name: Firstname,
            API.PARAMS.last_name: LastName,
            API.PARAMS.gender: Gender,
            API.PARAMS.birthday: Birthday,
            API.PARAMS.location: Location,
            API.PARAMS.language: language,
            API.PARAMS.relationship: RelationShip,
            API.PARAMS.work_status: workStatus,
            API.PARAMS.education: Education,
            
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditProfileModel.EditProfileSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditProfileModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editLooks(AccessToken:String,Color:String,Body:String,Height:String,Ethnicity:String, completionBlock: @escaping (_ Success:EditLooksModel.EditLooksSuccessModel?,_ SessionError:EditLooksModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.colour: Color,
            API.PARAMS.body: Body,
            API.PARAMS.height: Height,
            API.PARAMS.ethnicity: Ethnicity
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditLooksModel.EditLooksSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditLooksModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editPersonality(AccessToken:String,Character:String,Children:String,Friends:String,Pet:String, completionBlock: @escaping (_ Success:EditPersonalityModel.EditPersonalitySuccessModel?,_ SessionError:EditPersonalityModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.character: Character,
            API.PARAMS.children: Children,
            API.PARAMS.friends: Friends,
            API.PARAMS.pets: Pet
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditPersonalityModel.EditPersonalitySuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditPersonalityModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editLifeStyle(AccessToken:String,Livewith:String,Car:String,Religion:String,smoke:String,Drink:String,Travel:String, completionBlock: @escaping (_ Success:EditLifeStyleModel.EditLifeSuccessStyleModel?,_ SessionError:EditLifeStyleModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.live_with: Livewith,
            API.PARAMS.car: Car,
            API.PARAMS.religion: Religion,
            API.PARAMS.smoke: smoke,
            API.PARAMS.drink: Drink,
            API.PARAMS.travel: Travel
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditLifeStyleModel.EditLifeSuccessStyleModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditLifeStyleModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editFavourite(AccessToken:String,Music:String,Dish:String,Song:String,Hobby:String,City:String,Sport:String,Book:String,Movie:String,Color:String,Tvshow:String, completionBlock: @escaping (_ Success:EditFavouriteModel.EditFavouriteSuccessModel?,_ SessionError:EditFavouriteModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.music: Music,
            API.PARAMS.dish: Dish,
            API.PARAMS.song: Song,
            API.PARAMS.hobby: Hobby,
            API.PARAMS.city: City,
            API.PARAMS.sport: Sport,
            API.PARAMS.book: Book,
            API.PARAMS.movie: Movie,
            API.PARAMS.colour: Color,
            API.PARAMS.tv: Tvshow,
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(EditFavouriteModel.EditFavouriteSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(EditFavouriteModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateAboutMe(AccessToken:String,  AboutMeText: String, completionBlock: @escaping (_ Success:UpdateAboutMeModel.UpdateAboutMeSuccessModel?,_ SessionError:UpdateAboutMeModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.about: AboutMeText
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateAboutMeModel.UpdateAboutMeSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateAboutMeModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateInterest(AccessToken:String,  InterestText: String, completionBlock: @escaping (_ Success:UpdateInterestModel.UpdateInterestSuccessModel?,_ SessionError:UpdateInterestModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.interest: InterestText
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            log.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateInterestModel.UpdateInterestSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateInterestModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateTwoaFactor(UserId:Int,AccessToken:String,email:String, completionBlock: @escaping (_ Success:TwoFactorVerifyCodeModel.TwoFactorVerifyCodeSuccessModel?,_ SessionError:TwoFactorVerifyCodeModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.new_email: email
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.TWO_FACTOR_SETTINGS_CONSTANT.TWO_FACTOR_SETTINGS_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.TWO_FACTOR_SETTINGS_CONSTANT.TWO_FACTOR_SETTINGS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(TwoFactorVerifyCodeModel.TwoFactorVerifyCodeSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(TwoFactorVerifyCodeModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func verifyTwoFactorCode(UserId:Int,AccessToken:String,twoFactorCode:String, completionBlock: @escaping (_ Success:UserProfileModel.UserProfileSuccessModel?,_ SessionError:UserProfileModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.two_factor_email_code: twoFactorCode
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.UserProfileSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    log.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.sessionErrorModel.self, from: data!)
                    log.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                log.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateTwoFactorProfile(UserId:Int,AccessToken:String,twoFactor:String, completionBlock: @escaping (_ Success:UpdateTwoFactorInProfileModel.UpdateTwoFactorInProfileSuccessModel?,_ SessionError:UpdateTwoFactorInProfileModel.sessionErrorModel?, Error?) ->()){
           
           let params = [
               
//               API.PARAMS.user_id: UserId,
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.two_factor: twoFactor
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
           log.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
           log.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   guard let apiStatus = res["code"]  as? Int else {return}
                   if apiStatus ==  API.ERROR_CODES.E_200{
                       log.verbose("apiStatus Int = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UpdateTwoFactorInProfileModel.UpdateTwoFactorInProfileSuccessModel.self, from: data!)
                       completionBlock(result,nil,nil)
                   }else if apiStatus ==  API.ERROR_CODES.E_400{
                       log.verbose("apiStatus String = \(apiStatus)")
                       let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UpdateTwoFactorInProfileModel.sessionErrorModel.self, from: data!)
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


