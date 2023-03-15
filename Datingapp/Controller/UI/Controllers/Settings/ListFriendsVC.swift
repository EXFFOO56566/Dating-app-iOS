//
//  ListFriendsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 3/13/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork

class ListFriendsVC: BaseVC, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var noFavLabel: UILabel!
    
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var noFavImage: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var mediaFiles = [String]()
    var FriendList: [GetListFiendModel.Datum] = []
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.listFiend()
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    private func setupUI(){
        self.noFavImage.tintColor = .Main_StartColor
        self.friendsLabel.text = NSLocalizedString("Friends", comment: "Friends")
        self.noFavLabel.text = NSLocalizedString("You have No Friends", comment: "You have No Friends")
        collectionView.register(R.nib.listFriendCollectionItem(), forCellWithReuseIdentifier: "ListFriendCollectionItem")
        if ControlSettings.shouldShowAddMobBanner{
            if ControlSettings.googleAds {
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:ControlSettings.interestialAddUnitId,
                                       request: request,
                                       completionHandler: { (ad, error) in
                                        if let error = error {
                                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                            return
                                        }
                                        self.interstitial = ad
                                       }
                )
            }
        }
    }
    func CreateAd() -> GADInterstitialAd {
        
        GADInterstitialAd.load(withAdUnitID:ControlSettings.interestialAddUnitId,
                               request: GADRequest(),
                               completionHandler: { (ad, error) in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                self.interstitial = ad
                               }
        )
        return  self.interstitial
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func listFiend(){
        self.showProgressDialog(text: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                FriendManager.instance.getListFriends(AccessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.dismissProgressDialog {
                                self.FriendList = success?.data ?? []
                                if self.FriendList.isEmpty{
                                    self.noFavImage.isHidden = false
                                    self.noFavLabel.isHidden = false
                                }else{
                                    self.noFavImage.isHidden = true
                                    self.noFavLabel.isHidden = true
                                    self.collectionView.reloadData()
                                }
                                log.debug("userList = \(success?.message ?? "")")
                            }
                        })
                        
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListFriendCollectionItem", for: indexPath) as! ListFriendCollectionItem
        let object = self.FriendList[indexPath.row]
        cell.vc = self
        cell.bind(object)
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40)/2
        let height = (collectionView.frame.size.height - 24)/2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if AppInstance.instance.addCount == ControlSettings.interestialCount {
        if ControlSettings.facebookAds {
            if let ad = interstitial {
                interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.fbplacementID)
                interstitialAd1?.delegate = self
                interstitialAd1?.load()
            } else {
                print("Ad wasn't ready")
            }
        }else if ControlSettings.googleAds{
            interstitial.present(fromRootViewController: self)
                interstitial = CreateAd()
                AppInstance.instance.addCount = 0
        }
    }
    AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
          self.mediaFiles.removeAll()
          let userObject = FriendList[indexPath.row]
          let vc = R.storyboard.main.showUserDetailsVC()
    
    let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText: userObject.countryTxt ?? "", relationshipText:  "", bodyText:  "", smokeText: "", ethnicityText:"" , petsText: "", genderText: "", about: "" ?? "", isFriend: false, isFavourite: false, is_friend_request: false)
    
//    let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText: userObject.countryTxt ?? "", relationshipText:  "", bodyText:  "", smokeText: "", ethnicityText:"" , petsText: "", genderText: "", about: "" ?? "")
    
          vc?.mediaFiles = mediaFiles
          vc?.object = object
          self.navigationController?.pushViewController(vc!, animated: true)
      }
}
