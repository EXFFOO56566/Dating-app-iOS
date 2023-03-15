

import Foundation
class GetSettingsModel:BaseModel{

    // MARK: - Welcome
    struct GetSettingsSuccessModel: Codable {
        let message: String?
        let data: DataClass?
        let code: Int?
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let loadConfigInSession, metaDescription, metaKeywords, defaultTitle: String?
        let siteName, defaultLanguage, smtpOrMail, smtpHost: String?
        let smtpUsername, smtpPassword, smtpEncryption, smtpPort: String?
        let siteEmail, theme, allLogin, googleLogin: String?
        let facebookLogin, twitterLogin, linkedinLogin, vkontakteLogin: String?
        let facebookAppID, facebookAppKey, googleAppID, googleAppKey: String?
        let twitterAppID, twitterAppKey, linkedinAppID, linkedinAppKey: String?
        let vkontakteAppID, vkontakteAppKey, instagramAppID, instagramAppkey: String?
        let instagramLogin, smsOrEmail, smsPhoneNumber, paypalID: String?
        let paypalSecret, paypalMode, currency, lastBackup: String?
        let amazoneS3, bucketName, amazoneS3Key, amazoneS3SKey: String?
        let region, smsTPhoneNumber, smsTwilioUsername, smsTwilioPassword: String?
        let smsProvider, profilePictureWidthCrop, profilePictureHeightCrop, userDefaultAvatar: String?
        let profilePictureImageQuality, emailValidation, stripeSecret, stripeID: String?
        let pushID, pushKey: String?
        let terms, about, privacyPolicy: String?
        let facebookURL, twitterURL, googleURL: String?
        let currencySymbol, bagOfCreditsPrice, bagOfCreditsAmount, boxOfCreditsPrice: String?
        let boxOfCreditsAmount, chestOfCreditsPrice, chestOfCreditsAmount, weeklyProPlan: String?
        let monthlyProPlan, yearlyProPlan, lifetimeProPlan, workerUpdateDelay: String?
        let profileRecordViewsMinute, costPerGift, deleteAccount, userRegistration: String?
        let maxUpload, mimeTypes, normalBoostMeCreditsPrice, moreStickersCreditsPrice: String?
        let proBoostMeCreditsPrice, boostExpireTime, notProChatLimitDaily, notProChatCredit: String?
        let notProChatStickersCredit, notProChatStickersLimit, costPerXvisits, xvisitsExpireTime: String?
        let costPerXmatche, xmatcheExpireTime, costPerXlike, xlikeExpireTime: String?
        let googlePlaceAPI, wowonderLogin, wowonderAppID, wowonderAppKey: String?
        let wowonderDomainURI: String?
        let wowonderDomainIcon: String?
        let bankTransferNote, maxSwaps, stripeVersion, payseraProjectID: String?
        let payseraPassword, payseraTestMode, messageRequestSystem, videoChat: String?
        let audioChat, videoAccountSid, videoAPIKeySid, videoAPIKeySecret: String?
        let giphyAPI, defaultUnit, maintenanceMode, displaymode: String?
        let bankDescription, version: String?
        let avcallPro, proSystem, imgBlurAmount, emailNotification: String?
        let activationLimitSystem, maxActivationRequest, activationRequestTimeLimit, freeFeatures: String?
        let oppositeGender, imageVerification, pendingVerification, push: String?
        let spamWarning, imageVerificationStart: String?
        let isRTL: Bool?
        let uri: String?
        let height: [[String: String]]?
        let notification: [Notification]?
        let gender: [[String: String]]?
        let blogCategories: [BlogCategory]?
        let countries: [[String: Country]]?
        let hairColor, travel, drink, smoke: [[String: String]]?
        let religion, car, liveWith, pets: [[String: String]]?
        let friends, children, character, body: [[String: String]]?
        let ethnicity, education, workStatus, relationship: [[String: String]]?
        let language: [[String: String]]?
        
        enum CodingKeys: String, CodingKey {
            case loadConfigInSession = "load_config_in_session"
            case metaDescription = "meta_description"
            case metaKeywords = "meta_keywords"
            case defaultTitle = "default_title"
            case siteName = "site_name"
            case defaultLanguage = "default_language"
            case smtpOrMail = "smtp_or_mail"
            case smtpHost = "smtp_host"
            case smtpUsername = "smtp_username"
            case smtpPassword = "smtp_password"
            case smtpEncryption = "smtp_encryption"
            case smtpPort = "smtp_port"
            case siteEmail, theme
            case allLogin = "AllLogin"
            case googleLogin, facebookLogin, twitterLogin, linkedinLogin
            case vkontakteLogin = "VkontakteLogin"
            case facebookAppID = "facebookAppId"
            case facebookAppKey
            case googleAppID = "googleAppId"
            case googleAppKey
            case twitterAppID = "twitterAppId"
            case twitterAppKey
            case linkedinAppID = "linkedinAppId"
            case linkedinAppKey
            case vkontakteAppID = "VkontakteAppId"
            case vkontakteAppKey = "VkontakteAppKey"
            case instagramAppID = "instagramAppId"
            case instagramAppkey, instagramLogin
            case smsOrEmail = "sms_or_email"
            case smsPhoneNumber = "sms_phone_number"
            case paypalID = "paypal_id"
            case paypalSecret = "paypal_secret"
            case paypalMode = "paypal_mode"
            case currency
            case lastBackup = "last_backup"
            case amazoneS3 = "amazone_s3"
            case bucketName = "bucket_name"
            case amazoneS3Key = "amazone_s3_key"
            case amazoneS3SKey = "amazone_s3_s_key"
            case region
            case smsTPhoneNumber = "sms_t_phone_number"
            case smsTwilioUsername = "sms_twilio_username"
            case smsTwilioPassword = "sms_twilio_password"
            case smsProvider = "sms_provider"
            case profilePictureWidthCrop = "profile_picture_width_crop"
            case profilePictureHeightCrop = "profile_picture_height_crop"
            case userDefaultAvatar
            case profilePictureImageQuality = "profile_picture_image_quality"
            case emailValidation
            case stripeSecret = "stripe_secret"
            case stripeID = "stripe_id"
            case pushID = "push_id"
            case pushKey = "push_key"
            case terms, about
            case privacyPolicy = "privacy_policy"
            case facebookURL = "facebook_url"
            case twitterURL = "twitter_url"
            case googleURL = "google_url"
            case currencySymbol = "currency_symbol"
            case bagOfCreditsPrice = "bag_of_credits_price"
            case bagOfCreditsAmount = "bag_of_credits_amount"
            case boxOfCreditsPrice = "box_of_credits_price"
            case boxOfCreditsAmount = "box_of_credits_amount"
            case chestOfCreditsPrice = "chest_of_credits_price"
            case chestOfCreditsAmount = "chest_of_credits_amount"
            case weeklyProPlan = "weekly_pro_plan"
            case monthlyProPlan = "monthly_pro_plan"
            case yearlyProPlan = "yearly_pro_plan"
            case lifetimeProPlan = "lifetime_pro_plan"
            case workerUpdateDelay = "worker_updateDelay"
            case profileRecordViewsMinute = "profile_record_views_minute"
            case costPerGift = "cost_per_gift"
            case deleteAccount
            case userRegistration = "user_registration"
            case maxUpload
            case mimeTypes = "mime_types"
            case normalBoostMeCreditsPrice = "normal_boost_me_credits_price"
            case moreStickersCreditsPrice = "more_stickers_credits_price"
            case proBoostMeCreditsPrice = "pro_boost_me_credits_price"
            case boostExpireTime = "boost_expire_time"
            case notProChatLimitDaily = "not_pro_chat_limit_daily"
            case notProChatCredit = "not_pro_chat_credit"
            case notProChatStickersCredit = "not_pro_chat_stickers_credit"
            case notProChatStickersLimit = "not_pro_chat_stickers_limit"
            case costPerXvisits = "cost_per_xvisits"
            case xvisitsExpireTime = "xvisits_expire_time"
            case costPerXmatche = "cost_per_xmatche"
            case xmatcheExpireTime = "xmatche_expire_time"
            case costPerXlike = "cost_per_xlike"
            case xlikeExpireTime = "xlike_expire_time"
            case googlePlaceAPI = "google_place_api"
            case wowonderLogin = "wowonder_login"
            case wowonderAppID = "wowonder_app_ID"
            case wowonderAppKey = "wowonder_app_key"
            case wowonderDomainURI = "wowonder_domain_uri"
            case wowonderDomainIcon = "wowonder_domain_icon"
            case bankTransferNote = "bank_transfer_note"
            case maxSwaps = "max_swaps"
            case stripeVersion = "stripe_version"
            case payseraProjectID = "paysera_project_id"
            case payseraPassword = "paysera_password"
            case payseraTestMode = "paysera_test_mode"
            case messageRequestSystem = "message_request_system"
            case videoChat = "video_chat"
            case audioChat = "audio_chat"
            case videoAccountSid = "video_accountSid"
            case videoAPIKeySid = "video_apiKeySid"
            case videoAPIKeySecret = "video_apiKeySecret"
            case giphyAPI = "giphy_api"
            case defaultUnit = "default_unit"
            case maintenanceMode = "maintenance_mode"
            case displaymode
            case bankDescription = "bank_description"
            case version
            case avcallPro = "avcall_pro"
            case proSystem = "pro_system"
            case imgBlurAmount = "img_blur_amount"
            case emailNotification
            case activationLimitSystem = "activation_limit_system"
            case maxActivationRequest = "max_activation_request"
            case activationRequestTimeLimit = "activation_request_time_limit"
            case freeFeatures = "free_features"
            case oppositeGender = "opposite_gender"
            case imageVerification = "image_verification"
            case pendingVerification = "pending_verification"
            case push
            case spamWarning = "spam_warning"
            case imageVerificationStart = "image_verification_start"
            case isRTL = "is_rtl"
            case uri
            case height = "Height"
            case notification = "Notification"
            case gender = "Gender"
            case blogCategories = "BlogCategories"
            case countries = "Countries"
            case hairColor = "HairColor"
            case travel = "Travel"
            case drink = "Drink"
            case smoke = "Smoke"
            case religion = "Religion"
            case car = "Car"
            case liveWith = "LiveWith"
            case pets = "Pets"
            case friends = "Friends"
            case children = "Children"
            case character = "Character"
            case body = "Body"
            case ethnicity = "Ethnicity"
            case education = "Education"
            case workStatus = "WorkStatus"
            case relationship = "Relationship"
            case language = "Language"
        }
    }
    
    // MARK: - BlogCategory
    struct BlogCategory: Codable {
        let the22700: String?
        
        enum CodingKeys: String, CodingKey {
            case the22700 = "22700"
        }
    }
    
    // MARK: - Country
    struct Country: Codable {
        let alpha2, alpha3, num, isd: String?
        let name: String?
        let continent: Continent?
    }
    
    enum Continent: String, Codable {
        case africa = "Africa"
        case antarctica = "Antarctica"
        case asia = "Asia"
        case europe = "Europe"
        case northAmerica = "North America"
        case oceania = "Oceania"
        case southAmerica = "South America"
    }
    
    // MARK: - Language
    struct Language: Codable {
        let english, arabic, dutch, french: String?
        let german, italian, portuguese, russian: String?
        let spanish, turkish: String?
    }
    
    // MARK: - Notification
    struct Notification: Codable {
        let visit, like, dislike, sendGift: String?
        let gotNewMatch, message, approveReceipt, disapproveReceipt: String?
        let acceptChatRequest, declineChatRequest, createStory, approveStory: String?
        let disapproveStory: String?
        
        enum CodingKeys: String, CodingKey {
            case visit, like, dislike
            case sendGift = "send_gift"
            case gotNewMatch = "got_new_match"
            case message
            case approveReceipt = "approve_receipt"
            case disapproveReceipt = "disapprove_receipt"
            case acceptChatRequest = "accept_chat_request"
            case declineChatRequest = "decline_chat_request"
            case createStory = "create_story"
            case approveStory = "approve_story"
            case disapproveStory = "disapprove_story"
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

}
