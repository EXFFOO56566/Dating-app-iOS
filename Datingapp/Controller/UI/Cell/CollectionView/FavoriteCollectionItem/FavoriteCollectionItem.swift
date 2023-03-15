//
//  FavoriteCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/22/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async

class FavoriteCollectionItem: UICollectionViewCell {
    
    @IBOutlet var avtImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var unFavButton: UIButton!
    
    var vc:FavoriteVC?
    var id:String? = ""
    var indexPath:Int? = 0
    
    
   override func awakeFromNib() {
          super.awakeFromNib()
    self.unFavButton.setTitle(NSLocalizedString("UnFavorite", comment: "UnFavorite"), for: .normal)
    unFavButton.setTitleColor(.Button_StartColor, for: .normal)
    unFavButton.borderColorV = .Button_StartColor
    self.avtImageView.circleView()
      }
    
    func bind (_ object:FetchFavoriteModel.Datum,index:Int){
        if object.userData?.firstName ?? "" == "" && object.userData?.lastName  == "" ?? "" {
            self.userNameLabel.text  = object.userData?.username ?? ""
        }else{
            self.userNameLabel.text = "\(object.userData?.firstName ?? "") \(object.userData?.lastName ?? "")"
        }
        let url = URL(string: object.userData?.avater ?? "")
        self.avtImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.id = object.userData?.id ?? ""
        self.indexPath = index
    
    }
    @IBAction func unFavButtonAction(_ sender: Any) {
        self.unFavorite(uid: self.id ?? "")
    }
    private func unFavorite(uid:String){
              if Connectivity.isConnectedToNetwork(){
                  self.vc?.showProgressDialog(text: "Loading...")
                  let accessToken = AppInstance.instance.accessToken ?? ""
                  Async.background({
                    FavoriteManager.instance.deleteFavorite(AccessToken: accessToken, uid: Int(uid)!) { (success, sessionError, error) in
                          if success != nil{
                              Async.main({
                                  self.vc?.dismissProgressDialog {
                                      log.debug("userList = \(success?.message ?? "")")
                                    self.vc?.favoriteUser.remove(at: self.indexPath ?? 0)
                                    self.vc?.collectionView.reloadData()
                                      self.vc?.view.makeToast(success?.message ?? "")
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
