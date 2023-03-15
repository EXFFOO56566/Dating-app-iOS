//
//  HotOrNotCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
class HotOrNotCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var ProfileImaGE: UIImageView!
    @IBOutlet weak var usrenameLabel: UILabel!
    
    var vc:TrendingVC?
    var hotOrNotVC:HotOrNotVC?
    var userID:Int? = 0
    var indexPath:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ object:HotOrNotModel.Datum){
        let url = URL(string: object.avater ?? "")
        self.ProfileImaGE.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        
        if object.firstName ?? "" == "" && object.lastName  == "" ?? "" {
            self.usrenameLabel.text  = object.username ?? ""
        }else{
            self.usrenameLabel.text = "\(object.firstName ?? "") \(object.lastName ?? "")"
        }
    }
    
    @IBAction func hotPressed(_ sender: Any) {
        sendHot()
    }
    @IBAction func notPressed(_ sender: Any) {
        sendNot()
        
    }
    private func sendHot(){
        if Connectivity.isConnectedToNetwork(){
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                HotOrNotManager.instance.addHot(AccessToken: accessToken, userId: self.userID ?? 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("userList = \(success?.cookie ?? 0)")
                            if self.vc != nil{
                                self.vc?.hotOrNotUsers.remove(at: self.indexPath ?? 0)
                                self.vc?.tableView.reloadData()
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC?.hotOrNotArray.remove(at: self.indexPath ?? 0)
                                self.hotOrNotVC?.tableView.reloadData()
                            }
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            if self.vc != nil{
                                self.vc!.dismissProgressDialog {
                                    
                                    self.vc!.view.makeToast(sessionError?.errors?.errorText ?? "")
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                }
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC!.dismissProgressDialog {
                                    
                                    self.hotOrNotVC!.view.makeToast(sessionError?.errors?.errorText ?? "")
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                }
                            }
                            
                        })
                    }else {
                        Async.main({
                            if self.vc != nil{
                                self.vc!.dismissProgressDialog {
                                    
                                    self.vc!.view.makeToast(error?.localizedDescription ?? "")
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                }
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC!.dismissProgressDialog {
                                    self.hotOrNotVC!.view.makeToast(error?.localizedDescription ?? "")
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                }
                            }
                            
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc!.view.makeToast(InterNetError)
        }
    }
    private func sendNot(){
        if Connectivity.isConnectedToNetwork(){
            
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                HotOrNotManager.instance.addNot(AccessToken: accessToken, userId: self.userID ?? 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("userList = \(success?.cookie ?? 0)")
                            
                            if self.vc != nil{
                                self.vc?.hotOrNotUsers.remove(at: self.indexPath ?? 0)
                                self.vc?.tableView.reloadData()
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC?.hotOrNotArray.remove(at: self.indexPath ?? 0)
                                self.hotOrNotVC?.tableView.reloadData()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            if self.vc != nil{
                                self.vc!.dismissProgressDialog {
                                    
                                    self.vc!.view.makeToast(sessionError?.errors?.errorText ?? "")
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                }
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC!.dismissProgressDialog {
                                    
                                    self.hotOrNotVC!.view.makeToast(sessionError?.errors?.errorText ?? "")
                                    log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                }
                            }
                        })
                    }else {
                        Async.main({
                            if self.vc != nil{
                                self.vc!.dismissProgressDialog {
                                    
                                    self.vc!.view.makeToast(error?.localizedDescription ?? "")
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                }
                            }else if self.hotOrNotVC != nil{
                                self.hotOrNotVC!.dismissProgressDialog {
                                    self.hotOrNotVC!.view.makeToast(error?.localizedDescription ?? "")
                                    log.error("error = \(error?.localizedDescription ?? "")")
                                }
                            }
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc!.view.makeToast(InterNetError)
        }
    }
}

