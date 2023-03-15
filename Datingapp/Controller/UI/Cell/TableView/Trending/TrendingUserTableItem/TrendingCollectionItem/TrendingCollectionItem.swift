//
//  TrendingCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class TrendingCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var vc:UIViewController?
    var baseVC:BaseVC?
    var uid:Int? = 0
    var status:Bool? = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func heartPressed(_ sender: Any) {
        self.likeDislikeMatch(likeString: String(self.uid ?? 0), disLikeString: String(self.uid ?? 0))
        
    }
    func bind(_ object:SearchModel.Datum){
        let url = URL(string: object.avater ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.timeLabel.text =  self.setTimestamp(epochTime: String(object.lastseen!))
        
        if object.firstName ?? "" == "" && object.lastName  == "" ?? "" {
            self.userNameLabel.text  = object.username ?? ""
        }else{
            self.userNameLabel.text = "\(object.firstName ?? "") \(object.lastName ?? "")"
        }
        self.uid = object.id ?? 0
    
    }
    
    func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
        
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)
        
        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }
                        
                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
     private func likeDislikeMatch(likeString:String,disLikeString:String){
        self.status = !self.status!
        if status!{
             self.likeBtn.setImage(R.image.red_heart_ic(), for: .normal)
        }else{
             self.likeBtn.setImage(R.image.heart(), for: .normal)
        }
         if Connectivity.isConnectedToNetwork(){
             let accessToken = AppInstance.instance.accessToken ?? ""
             Async.background({
                 LikesManager.instance.likeMatches(AccessToken: accessToken, LikesIdString: likeString, DisLikesIdString: disLikeString, completionBlock: { (success, sessionError, error) in
                     if success != nil{
                         Async.main({
                             
                            self.baseVC?.dismissProgressDialog {
                                 log.debug("userList = \(success?.message ?? "")")
//                                if success?.message == "Like successfully added"{
//                                     self.likeBtn.setImage(R.image.red_heart_ic(), for: .normal)
//                                }else{
//                                     self.likeBtn.setImage(R.image.heart(), for: .normal)
//                                }
                               
                             }
                         })
                     }else if sessionError != nil{
                         Async.main({
                            self.baseVC?.dismissProgressDialog {
                                 
                                self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                                 log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                             }
                         })
                     }else {
                         Async.main({
                            self.baseVC?.dismissProgressDialog {
                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
                                 log.error("error = \(error?.localizedDescription ?? "")")
                             }
                         })
                     }
                 })
             })
             
         }else{
             log.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
         }
     }
}
