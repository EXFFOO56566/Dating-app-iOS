//
//  OnlineUserTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork

class OnlineUserTableItem: UITableViewCell, FBInterstitialAdDelegate {

    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var collectionView: UICollectionView!
    var object:[TrendingModel.Datum] = []
    var vc:TrendingVC?
    var mediaFiles = [String]()
    var interstitial: GADInterstitialAd!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")

            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: vc)
            }
    }
    
    private func setupUI(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        collectionView.register(R.nib.onlineUserCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.onlineUserCollectionItem.identifier)
        collectionView.register(R.nib.addStoryCollectionCell(), forCellWithReuseIdentifier: R.reuseIdentifier.addStoryCollectionCell.identifier)
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
    
    func bind(object:[TrendingModel.Datum]){
        self.object = object
        self.collectionView.reloadData()
        
    }
}
extension OnlineUserTableItem:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if AppInstance.instance.userProfile?.data?.isPro == "1"{
            return self.object.count
            
        }else{
//            return self.object.count + 1
            return self.object.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if AppInstance.instance.userProfile?.data?.isPro == "1"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.onlineUserCollectionItem.identifier, for: indexPath) as? OnlineUserCollectionItem
            let object = self.object[indexPath.row]
            cell?.bind(object)
            return cell!
        }else{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.addStoryCollectionCell.identifier, for: indexPath) as? AddStoryCollectionCell
                let object = AppInstance.instance.userProfile?.data?.avater ?? ""
                cell?.bind(object)
                return cell!
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.onlineUserCollectionItem.identifier, for: indexPath) as? OnlineUserCollectionItem
//                let object = self.object[indexPath.row + 1]
                let object = self.object[indexPath.row]

                cell?.bind(object)
                return cell!
            }
        }
        
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
                    interstitial.present(fromRootViewController: vc!)
                    interstitial = CreateAd()
                    AppInstance.instance.addCount = 0
            }
        }
               AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        if AppInstance.instance.userProfile?.data?.isPro == "1"{
            self.mediaFiles.removeAll()
            let userObject = object[indexPath.row]
            for item in userObject.mediafiles!{
                self.mediaFiles.append(item.full ?? "")
            }
            let vc = R.storyboard.main.showUserDetailsVC()
            
            let object = ShowUserProfileModel(id: Int(userObject.id ?? "0")!, online: Int(userObject.online ?? "0")!, lastseen: Int(userObject.lastseen ?? "0"), username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:Int(userObject.relationship ?? "0"), height: userObject.height ?? "", body: Int(userObject.body ?? "0"), smoke: Int(userObject.smoke ?? "0"), ethnicity: Int(userObject.ethnicity ?? "0"), pets: Int(userObject.pets ?? "0"), gender: userObject.gender ?? "", countryText: userObject.countryTxt ?? "", relationshipText: userObject.relationshipTxt ?? "", bodyText: userObject.bodyTxt ?? "", smokeText: userObject.smokeTxt ?? "", ethnicityText: userObject.ethnicityTxt ?? "", petsText: userObject.pets ?? "", genderText: userObject.genderTxt ?? "", about: userObject.about ?? "", isFriend: false, isFavourite: false, is_friend_request: false)
            
//            let object = ShowUserProfileModel(id: Int(userObject.id ?? "0")!, online: Int(userObject.online ?? "0")!, lastseen: Int(userObject.lastseen ?? "0"), username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:Int(userObject.relationship ?? "0"), height: userObject.height ?? "", body: Int(userObject.body ?? "0"), smoke: Int(userObject.smoke ?? "0"), ethnicity: Int(userObject.ethnicity ?? "0"), pets: Int(userObject.pets ?? "0"), gender: userObject.gender ?? "", countryText: userObject.countryTxt ?? "", relationshipText: userObject.relationshipTxt ?? "", bodyText: userObject.bodyTxt ?? "", smokeText: userObject.smokeTxt ?? "", ethnicityText: userObject.ethnicityTxt ?? "", petsText: userObject.pets ?? "", genderText: userObject.genderTxt ?? "", about: userObject.about ?? "")
            
            vc?.mediaFiles = mediaFiles
            vc?.object = object
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
            
        }else{
            if indexPath.row == 0{
                let vc = R.storyboard.credit.upgradeAccountVC()
                vc?.delegate = self
                vc?.modalPresentationStyle = .fullScreen
                vc?.modalTransitionStyle = .coverVertical
                self.vc?.present(vc!, animated: true, completion: nil)
                
            }else{
                self.mediaFiles.removeAll()
                let userObject = object[indexPath.row]
                for item in userObject.mediafiles!{
                    self.mediaFiles.append(item.full ?? "")
                }
                let vc = R.storyboard.main.showUserDetailsVC()
                
                let object = ShowUserProfileModel(id: Int(userObject.id ?? "0")!, online: Int(userObject.online ?? "0")!, lastseen: Int(userObject.lastseen ?? "0"), username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:Int(userObject.relationship ?? "0"), height: userObject.height ?? "", body: Int(userObject.body ?? "0"), smoke: Int(userObject.smoke ?? "0"), ethnicity: Int(userObject.ethnicity ?? "0"), pets: Int(userObject.pets ?? "0"), gender: userObject.gender ?? "", countryText: userObject.countryTxt ?? "", relationshipText: userObject.relationshipTxt ?? "", bodyText: userObject.bodyTxt ?? "", smokeText: userObject.smokeTxt ?? "", ethnicityText: userObject.ethnicityTxt ?? "", petsText: userObject.pets ?? "", genderText: userObject.genderTxt ?? "", about: userObject.about ?? "", isFriend: false, isFavourite: false, is_friend_request: false)
                
//                let object = ShowUserProfileModel(id: Int(userObject.id ?? "0")!, online: Int(userObject.online ?? "0")!, lastseen: Int(userObject.lastseen ?? "0"), username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:Int(userObject.relationship ?? "0"), height: userObject.height ?? "", body: Int(userObject.body ?? "0"), smoke: Int(userObject.smoke ?? "0"), ethnicity: Int(userObject.ethnicity ?? "0"), pets: Int(userObject.pets ?? "0"), gender: userObject.gender ?? "", countryText: userObject.countryTxt ?? "", relationshipText: userObject.relationshipTxt ?? "", bodyText: userObject.bodyTxt ?? "", smokeText: userObject.smokeTxt ?? "", ethnicityText: userObject.ethnicityTxt ?? "", petsText: userObject.pets ?? "", genderText: userObject.genderTxt ?? "", about: userObject.about ?? "")
                vc?.mediaFiles = mediaFiles
                vc?.object = object
                self.vc?.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90.0, height: 100.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10.0
    }
    
    
}
extension OnlineUserTableItem:movetoPayScreenDelegate{
    func moveToPayScreen(status: Bool, payType: String?, amount: Int, description: String,membershipType:Int?,credits:Int?) {
        if !status{
            let vc = R.storyboard.credit.bankTransferVC()
            vc?.payType = payType ?? ""
            vc?.amount = amount
            vc?.Description = description
            vc?.memberShipType = membershipType
            vc?.credits = credits ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = R.storyboard.credit.payVC()
            vc?.payType = payType ?? ""
            vc?.amount = amount
            vc?.Description = description
            vc?.memberShipType = membershipType
            vc?.credits = credits ?? 0
            self.vc?.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
    }
    
    
}
