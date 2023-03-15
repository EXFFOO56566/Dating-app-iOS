
import Foundation
import UIKit


struct AppConstant {
    //cert key for Quickdate
    //Demo Key
    /*
     VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OT1JuQkhXa2hPYUdKVlZqVldWekZ2WVRGSmVGZHFXbGhXUlRWTVdUQmtUMU5XVmxsV2JIQk9ZVzEzZHlOV01uaFRVekpGZUdORmFGaFhSM2hoV1ZkemVFMUdVWGRWYlRWc1lYcFZNVlJWVWtOVWJGcElXa1JhVlZKc1NubFVWbFUxVTBaU1dWVnJOVk5TV0VKNFZqRlNTMVJ0Vm5KUFZtaFdWMGQ0YUZWcldsWk5RVDA5UURFME9UZzFPQ1F5TkRNNE5qY3lNZz09
     
     */
    
    static let key = "VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OT1JuQkhXa2hPYUdKVlZqVldWekZ2WVRGSmVGZHFXbGhXUlRWTVdUQmtUMU5XVmxsV2JIQk9ZVzEzZHlOV01uaFRVekpGZUdORmFGaFhSM2hoV1ZkemVFMUdVWGRWYlRWc1lYcFZNVlJWVWtOVWJGcElXa1JhVlZKc1NubFVWbFUxVTBaU1dWVnJOVk5TV0VKNFZqRlNTMVJ0Vm5KUFZtaFdWMGQ0YUZWcldsWk5RVDA5UURFME9UZzFPQ1F5TkRNNE5qY3lNZz09"
}

struct ControlSettings {
    static let Appname = "Quickdate"
    static let showSocicalLogin = false
    static let isVideo = true
    static let isAudio = true
    static var shouldShowAddMobBanner:Bool = true
   
    static var interestialCount:Int? = 3
    /*
     * change it with your wowonder Script Server key
     */
    static let wowonder_ServerKey = "131c471c8b4edf662dd0ebf7adf3c3d7365838b9"
    /*
     * change it with your wowonder Script URL
     */
    static let wowonder_URL = "https://demo.wowonder.com/"
    /*
     * change it with your banner Ad ID
     */
    static let addUnitId = "ca-app-pub-3940256099942544/2934735716"
    /*
     * change it with your InterestialAddUnit ID
     */
    static let interestialAddUnitId = "ca-app-pub-3940256099942544/4411468910"
    /*
     * change it with your facebook placementID
     */
    static let fbplacementID = "1121123558333256_1121124154999863"
    
    static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
    static let googleApiKey = "AIzaSyB9hBrJwdQM3oycf_j-53XKrG-hxW9rYt0"
    /*
     * change it with your onesignal app ID
     */
    static let oneSignalAppId = "f24d6c75-6e6d-4797-aa30-553bda1c32e9"
    /*
     * Change it with your stripe ID
     */
    static let stripeId = "pk_test_PT6I0ZbUz3Kie6yMvWLPrO5f00scXxDHaQ"
    /*
     * Terms, about,help Links will be changed according to your website
     */
    static let HelpLink = "\(baseURL)contact"
    static let aboutLink = "\(baseURL)about"
    static let Terms = "\(baseURL)terms"
    
    /*
     * Change this to your website URL
     */
    static let baseURL = "https://quickdatescript.com/"
    /*
     * Get google API key and remove it with yours
     */
    static let googlePlacesAPIKey = "AIzaSyAhreHQzmrv5tCGMgw4CGTMayusmUlbAaI"
   
    /*
     * if you want to enable facebook ads, make facebook variable value to true and google variable value to false
     * if you want oenable google ads, make google variable value to true and facebook variable value to false
     */
    static let facebookAds = false
    static let googleAds = true
    
    //you will get this from brainTree Sandbox account
    static let paypalAuthorizationToken = "sandbox_zjzj7brd_fzpwr2q9pk2m568s"
    /*
     * in this you need replace your bundle id before .payment
     * you need to add this URL scheme in your Project info list
     */
    static let BrainTreeURLScheme = "com.ScriptSun.QuickDateiOS.App.iOS.payments"
    
    
}

extension UIColor {
    
//    64265C
    //64265C
    @nonobjc class var Main_StartColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#64265C")
    }
    @nonobjc class var Main_EndColor: UIColor {
           return UIColor.hexStringToUIColor(hex: "#A731A0")
       }
    
    @nonobjc class var Button_StartColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#64265C")
    }
    
    @nonobjc class var Button_EndColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#A731A0")
    }
    @nonobjc class var Button_TextColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#FFFFFF")
    }
}
