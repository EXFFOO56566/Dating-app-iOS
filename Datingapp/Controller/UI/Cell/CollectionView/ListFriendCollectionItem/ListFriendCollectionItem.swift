//
//  ListFriendCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/23/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

import Async
import QuickdateSDK
class ListFriendCollectionItem: UICollectionViewCell {
    @IBOutlet var unfriendBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    var vc = ListFriendsVC()
    var uid:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func unfriendBtn(_ sender: Any) {
        self.friendUnFriend(uid: uid ?? 0)
    }
    
    func bind(_ object:GetListFiendModel.Datum){
        self.uid = object.id ?? 0
        
        let url = URL(string: object.avater ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.firstName ?? "" == "" && object.lastName  == "" ?? "" {
            self.usernameLabel.text  = object.username ?? ""
        }else{
            self.usernameLabel.text = "\(object.firstName ?? "") \(object.lastName ?? "")"
        }
    }
    private func friendUnFriend(uid:Int){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let uid1 = String(uid)
            
            Async.background({
                
                AddFriendRequestManager.instance.AddRequest(AccessToken: accessToken, uid:uid1) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                if success?.message == "Request deleted"{
                                    self.unfriendBtn.setTitle("Add Friend", for: .normal)
                                }else{
                                    self.unfriendBtn.setTitle("Remove friend", for: .normal)
                                }
                                self.vc.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                
                                self.vc.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc.dismissProgressDialog {
                                self.vc.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
        
    }
}
