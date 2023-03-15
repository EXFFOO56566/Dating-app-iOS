//
//  FriendRequestTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/3/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
class FriendRequestTableItem: UITableViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    var uid:Int? = 0
    var vc:RequestVC?
    var baseVC:BaseVC?
    var indexPath:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.circleView()
        self.notifyTypeIcon.circleView()
          self.notifyTypeIcon.backgroundColor = .Main_StartColor
        self.selectBtn.backgroundColor = .Button_StartColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func bind(_ object:NotificationModel.Datum,Type:String,index:Int){
        if Type == "friend_request"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text =  NSLocalizedString("Requested to be a friend with you", comment: "Requested to be a friend with you")
            self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }
        
        if let avatarURL = URL(string: object.notifier?.avater ?? "") {
            avatarImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            avatarImageView.image = UIImage(named: "no_profile_image")
        }
        self.userLabel.text = object.notifier?.firstName ?? ""
        self.uid = object.notifier?.id ?? 0
        self.indexPath = index
        
    }
    @IBAction func AcceptPressed(_ sender: Any) {
        approveFriend(uid: self.uid ?? 0)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.disApproveFriend(uid: self.uid ?? 0)
    }
    private func approveFriend(uid:Int){
        
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            FriendManager.instance.approveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                            self.vc?.friendRequest.remove(at: self.indexPath ?? 0)
                            self.vc?.tableVIew.reloadData()
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
            }
        })
    }
    private func disApproveFriend(uid:Int){
        
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            FriendManager.instance.disApproveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                             self.vc?.friendRequest.remove(at: self.indexPath ?? 0)
                            self.vc?.tableVIew.reloadData()
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
            }
        })
    }
    
}
