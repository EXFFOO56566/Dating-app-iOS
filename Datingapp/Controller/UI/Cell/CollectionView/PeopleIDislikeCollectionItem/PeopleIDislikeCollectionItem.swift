//
//  PeopleIDislikeCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/23/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class PeopleIDislikeCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var vc:DislikeUsersVC?
    var id:Int? = 0
    var indexpath:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.circleView()
    }
    
    func bind(_ object:LikeDislikeModel.Datum,index:Int ){
        let url = URL(string: object.userData?.avater ?? "")
        self.dateLabel.text = self.vc!.setTimestamp(epochTime: String(object.lastseen ?? 0 ))
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.id = object.id ?? 0
        self.indexpath = index
        if object.userData?.firstName ?? "" == "" && object.userData?.lastName  == "" ?? "" {
            self.usernameLabel.text  = object.userData?.username ?? ""
        }else{
            self.usernameLabel.text = "\(object.userData?.firstName ?? "") \(object.userData?.lastName ?? "")"
        }
        
    }
    
    @IBAction func disHeartPressed(_ sender: Any) {
        self.deleteLikeUser()
    }
    
    private func deleteLikeUser(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                LikeDislikeMananger.instance.deleteDislike(AccessToken: accessToken, id: self.id ?? 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc!.dismissProgressDialog {
                                self.vc?.dislikeUsers.remove(at: self.indexpath ?? 0)
                                self.vc?.collectionView.reloadData()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
}
