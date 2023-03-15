//
//  FavoriteVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/22/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
import GoogleMobileAds
import FBAudienceNetwork

class FavoriteVC: BaseVC, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteUser = [FetchFavoriteModel.Datum]()
    var mediaFiles = [String]()
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchData()
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    private func setupUI(){
          self.noImage.tintColor = .Main_StartColor
        collectionView.register(R.nib.favoriteCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.favoriteCollectionItem.identifier)
        self.favoriteLabel.text = NSLocalizedString("Favorite", comment: "Favorite")
        self.noLabel.text = NSLocalizedString("There is no Favourite User", comment: "There is no Favourite User")
        if ControlSettings.shouldShowAddMobBanner{
            
            if ControlSettings.googleAds{
                
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
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            self.favoriteUser.removeAll()
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                FavoriteManager.instance.fetchFavorite(AccessToken: accessToken, limit: 50, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                if (success?.data!.isEmpty)!{
                                    self.noImage.isHidden = false
                                    self.noLabel.isHidden = false
                                }else{
                                    self.favoriteUser = success?.data ?? []
                                    self.collectionView.reloadData()
                                    self.noImage.isHidden = true
                                    self.noLabel.isHidden = true
                                }
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
}
extension FavoriteVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoriteUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.favoriteCollectionItem.identifier, for: indexPath) as? FavoriteCollectionItem
        let  object = self.favoriteUser[indexPath.row]
        cell!.vc = self
        cell?.bind(object, index: indexPath.row)
        return cell!
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
        let userObject = favoriteUser[indexPath.row]
        for item in userObject.userData!.mediafiles!{
            self.mediaFiles.append(item.full ?? "")
        }
        let vc = R.storyboard.main.showUserDetailsVC()
        
        let object = ShowUserProfileModel(id: Int(userObject.userData?.id ?? "0")!, online: Int(userObject.userData?.online ?? "0")!, lastseen: Int(userObject.userData?.lastseen ?? "0"), username: userObject.userData?.username ?? "", avater: userObject.userData?.avater ?? "", country: userObject.userData?.country ?? "", firstName: userObject.userData?.firstName ?? "", lastName: userObject.userData?.lastName ?? "", location: userObject.userData?.location ?? "", birthday: userObject.userData?.birthday ?? "", language: userObject.userData?.language, relationship:Int(userObject.userData?.relationship ?? "0"), height: userObject.userData?.height ?? "", body: Int(userObject.userData?.body ?? "0"), smoke: Int(userObject.userData?.smoke ?? "0"), ethnicity: Int(userObject.userData?.ethnicity ?? "0"), pets: Int(userObject.userData?.pets ?? "0"), gender: userObject.userData?.gender ?? "", countryText: userObject.userData?.countryTxt ?? "", relationshipText: userObject.userData?.relationshipTxt ?? "", bodyText: userObject.userData?.bodyTxt ?? "", smokeText: userObject.userData?.smokeTxt ?? "", ethnicityText: userObject.userData?.ethnicityTxt ?? "", petsText: userObject.userData?.petsTxt ?? "", genderText: userObject.userData?.genderTxt ?? "", about: userObject.userData?.about, isFriend: false, isFavourite: false, is_friend_request: false)
        
//        let object = ShowUserProfileModel(id: Int(userObject.userData?.id ?? "0")!, online: Int(userObject.userData?.online ?? "0")!, lastseen: Int(userObject.userData?.lastseen ?? "0"), username: userObject.userData?.username ?? "", avater: userObject.userData?.avater ?? "", country: userObject.userData?.country ?? "", firstName: userObject.userData?.firstName ?? "", lastName: userObject.userData?.lastName ?? "", location: userObject.userData?.location ?? "", birthday: userObject.userData?.birthday ?? "", language: userObject.userData?.language, relationship:Int(userObject.userData?.relationship ?? "0"), height: userObject.userData?.height ?? "", body: Int(userObject.userData?.body ?? "0"), smoke: Int(userObject.userData?.smoke ?? "0"), ethnicity: Int(userObject.userData?.ethnicity ?? "0"), pets: Int(userObject.userData?.pets ?? "0"), gender: userObject.userData?.gender ?? "", countryText: userObject.userData?.countryTxt ?? "", relationshipText: userObject.userData?.relationshipTxt ?? "", bodyText: userObject.userData?.bodyTxt ?? "", smokeText: userObject.userData?.smokeTxt ?? "", ethnicityText: userObject.userData?.ethnicityTxt ?? "", petsText: userObject.userData?.petsTxt ?? "", genderText: userObject.userData?.genderTxt ?? "", about: userObject.userData?.about)
        
        vc?.mediaFiles = mediaFiles
        vc?.object = object
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
