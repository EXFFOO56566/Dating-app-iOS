

import Foundation
import UIKit
protocol didSelectStickerDelegate {
    func selectSticker(stickerId:Int)
}
protocol didSelectGiftDelegate {
    func selectGift(giftId:Int)
}

protocol didUpdateSettingsDelegate {
    func updateSettings(searchEngine:Int,randomUser:Int,matchProfile:Int,switch:UISwitch)
}
protocol didUpdateOnlineStatusDelegate {
    func updateOnlineStatus(status:Int,switch:UISwitch)
}



protocol movetoPayScreenDelegate {
    func moveToPayScreen(status:Bool,payType:String?,amount:Int,description:String,membershipType:Int?,credits:Int?)
}

protocol didSelectCountryDelegate {
    func selectCountry(status:Bool,countryString:String)
}
protocol FilterDelegate {
    func filter(status:Bool,searchArray:[SearchModel.Datum])
}
protocol didSetProfilesParamDelegate {
    func setProfileParam(status:Bool,selectedString:String,Type:String,index:Int)
}

protocol didSelectPaymentDelegate {
    func selectPayment(status:Bool,type:String,Index:Int,PaypalCredit:Int?)
}

protocol ReceiveCallDelegate {
    func receiveCall(status:Bool,profileImage:String,CallId:Int,AccessToken:String,RoomId:String,username:String,isVoice:Bool)
}
protocol selectGenderDelegate {
    func selectGender(type:String, TypeID:[String:String]?,status:Bool?)
}
protocol dismissTutorialViewDelegate {
    func dismissTutorialView(status : Bool)
}

protocol callReceivedDelegate {
    func callReceived()
}




