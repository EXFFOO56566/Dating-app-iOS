//
//  ShowUserDetailsTableitem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/21/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
import FittedSheets
class ShowUserDetailsTableitem: UITableViewCell{
    
    @IBOutlet weak var starimage: UIImageView!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarimage: UIImageView!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var addFriendView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var languagesLabel: UILabel!
    
    var mediaFiles = [String]()
    var vc:UIViewController?
    var baseVC:BaseVC?
    var object:ShowUserProfileModel?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
//        self.languagesLabel.text = NSLocalizedString("Languages", comment: "Languages")
//        collectionView.register(R.nib.showUserDetailsCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.showUserDetailsCollectionItem.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
//        giftView.setGradientBackground(colorOne:
//            UIColor(red: 139/255, green: 46/255, blue: 128/255, alpha: 1.0)
//            , colorTwo:  UIColor(red: 106/255, green: 37/255, blue: 99/255, alpha: 1.0), horizontal: true)
//        favoriteView.setGradientBackground(colorOne:
//            UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
//            , colorTwo:  UIColor(red: 139/255, green: 37/255, blue: 99/255, alpha: 1.0), horizontal: true)
//        addFriendView.setGradientBackground(colorOne:
//            UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
//            , colorTwo:  UIColor(red: 106/255, green: 37/255, blue: 99/255, alpha: 1.0), horizontal: true)
        let giftTap = UITapGestureRecognizer(target: self, action: #selector(self.giftTapped(_:)))
        giftView.addGestureRecognizer(giftTap)
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(self.favoriteTapped(_:)))
        favoriteView.addGestureRecognizer(favoriteTap)
        
        let friendTap = UITapGestureRecognizer(target: self, action: #selector(self.friendTapped(_:)))
        addFriendView.addGestureRecognizer(friendTap)
        
    }
    @objc func giftTapped(_ sender: UITapGestureRecognizer? = nil) {
        let vc = R.storyboard.chat.stickersViewController()
           let controller = SheetViewController(controller:vc!)
           controller.blurBottomSafeArea = true
           vc?.giftDelegate = self
           vc?.checkStatus = true
        self.vc?.present(controller, animated: false, completion: nil)
    }
    @objc func favoriteTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.favorite(uid: self.object?.id ?? 0)
    }
    @objc func friendTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.addRequest(uid:String(self.object?.id ?? 0))
    }
    @IBAction func backPressed(_ sender: Any) {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let block = UIAlertAction(title: NSLocalizedString("Block", comment: "Block") ,style: .default) { (action) in
            self.blockUser(UserId: self.object?.id ?? 0)
            
        }
        let report = UIAlertAction(title: NSLocalizedString("Report", comment: "Report"), style: .default) { (action) in
            
            self.reportUser(UserId: self.object?.id ?? 0)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancel)
        self.vc?.present(alert, animated: true, completion: nil)
        
    }
    
    func bind(_ object:ShowUserProfileModel,MediaFiles:[String]?){
        self.object = object
        self.nameLabel.text = "\(object.firstName ?? "") \(object.lastName ?? "")"
        let url = URL(string: object.avater ?? "")
        self.avatarimage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.mediaFiles = MediaFiles ?? []
        if object.isFriend == true{
            self.requestImage.image = UIImage(named: "Friendss")
        }
        if object.is_friend_request == true{
            self.requestImage.image = UIImage(named: "userclock")
        }
        if (object.isFavourite == false){
            self.starimage.image = R.image.star_ic()
        }
        else if (object.isFavourite == true){
            self.starimage.image = UIImage(named: "stares")
        }

    }
    
    
//    private func fetchData(gender:String){
//        if Connectivity.isConnectedToNetwork(){
//            self.hotOrNotArray.removeAll()
//            self.tableView.reloadData()
//            
//            self.showProgressDialog(text: "Loading...")
//            
//            let accessToken = AppInstance.instance.accessToken ?? ""
//            
//            Async.background({
//                HotOrNotManager.instance.getHotOrNot(AccessToken: accessToken, limit: 20, offset: 0, genders: gender) { (success, sessionError, error) in
//                    if success != nil{
//                        Async.main({
//                            log.debug("userList = \(success?.data ?? [])")
//                            self.hotOrNotArray = success?.data ?? []
//                            
//                            if self.hotOrNotArray.isEmpty{
//                                self.noImage.isHidden = false
//                                self.noImage.isHidden = false
//                            }else{
//                                self.noImage.isHidden = true
//                                self.noImage.isHidden = true
//                            }
//                            self.tableView.reloadData()
//                            
//                            
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
//                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                            }
//                        })
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(error?.localizedDescription ?? "")
//                                log.error("error = \(error?.localizedDescription ?? "")")
//                            }
//                        })
//                    }
//                }
//                
//            })
//            
//        }else{
//            log.error("internetError = \(InterNetError)")
//            self.view.makeToast(InterNetError)
//        }
//    }
    
    private func blockUser(UserId:Int){
        if Connectivity.isConnectedToNetwork(){
            self.baseVC?.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = UserId
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.vc?.view.makeToast(success?.message ?? "")
                                self.vc?.navigationController?.popViewController(animated: true)
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
    
    private func reportUser(UserId:Int){
        if Connectivity.isConnectedToNetwork(){
            self.baseVC?.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = UserId
            Async.background({
                ReportManager.instance.reportUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.vc?.view.makeToast(success?.message ?? "")
                                self.baseVC?.navigationController?.popViewController(animated: true)
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
    private func addRequest(uid:String){
        if Connectivity.isConnectedToNetwork(){
            self.baseVC?.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                AddFriendRequestManager.instance.AddRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                
                                if success?.message == "Request deleted"{
                                    self.requestImage.image = R.image.ic_AddFriend()
                                    self.vc?.view.makeToast("The Friendship has been canceled")
                                }else{
                                    self.requestImage.image = UIImage(named: "userclock")
                                    self.vc?.view.makeToast("The request has been sent, wait for approval")
                                }
//                                self.vc?.view.makeToast(success?.message ?? "")
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
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
    private func favorite(uid:Int){
        if Connectivity.isConnectedToNetwork(){
            self.baseVC?.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                FavoriteManager.instance.addFavorite(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                
                                if success?.message == "Success"{
//                                    self.starimage.image = R.image.star_yellow()
                                    self.starimage.image = UIImage(named: "stares")

                                }else{
                                    
//                                    self.requestImage.image = R.image.star_ic()
//                                    self.unFavorite(uid: self.object?.id ?? 0)
                                    
                                }
                                self.vc?.view.makeToast("User added to favorites")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                 self.unFavorite(uid: self.object?.id ?? 0)
//                                self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
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
        }else{
            log.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
    
    private func unFavorite(uid:Int){
           if Connectivity.isConnectedToNetwork(){
               self.baseVC?.showProgressDialog(text: "Loading...")
               let accessToken = AppInstance.instance.accessToken ?? ""
               Async.background({
                   FavoriteManager.instance.deleteFavorite(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                       if success != nil{
                           Async.main({
                               self.baseVC?.dismissProgressDialog {
                                   log.debug("userList = \(success?.message ?? "")")
                                   self.starimage.image = R.image.star_ic()
                                   
                                   self.vc?.view.makeToast("User removed from favorites")
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
           }else{
               log.error("internetError = \(InterNetError)")
               self.vc?.view.makeToast(InterNetError)
           }
       }
}
//extension ShowUserDetailsTableitem:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.mediaFiles.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.showUserDetailsCollectionItem.identifier, for: indexPath) as? ShowUserDetailsCollectionItem
//        let  object = self.mediaFiles[indexPath.row]
//        cell?.bind(object)
//        return cell!
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index = self.mediaFiles[indexPath.row]
//        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = Storyboard.instantiateViewController(identifier: "ShowImageVC") as! ShowImageController
//        vc.imageUrl = index
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        self.vc?.present(vc, animated: true, completion: nil)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
//
//}
extension ShowUserDetailsTableitem:didSelectGiftDelegate{
    func selectGift(giftId: Int) {
        sendGift(giftID: giftId)
    }
    private func sendGift(giftID:Int){
        let giftHashId = Int(arc4random_uniform(UInt32(100000)))
        let giftId = giftID
        let toID = self.object?.id  ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendGift(AccessToken: accessToken, To_userId: toID, GiftId: giftID, Hash_Id: giftHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
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
    }
}
