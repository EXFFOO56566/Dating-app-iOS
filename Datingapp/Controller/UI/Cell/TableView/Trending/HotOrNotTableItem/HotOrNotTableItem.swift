//
//  HotOrNotTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork

class HotOrNotTableItem: UITableViewCell, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var collectionView: UICollectionView!
    
    var interstitial: GADInterstitialAd!
    var object:[HotOrNotModel.Datum] = []
    var vc:TrendingVC?
    var mediaFiles = [String]()
    
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
        collectionView.register(R.nib.hotOrNotCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.hotOrNotCollectionItem.identifier)
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
    func bind(object:[HotOrNotModel.Datum]){
        self.object = object
        self.collectionView.reloadData()
        
    }
    
}
extension HotOrNotTableItem:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.object.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.hotOrNotCollectionItem.identifier, for: indexPath) as? HotOrNotCollectionItem
        let object = self.object[indexPath.row]
        cell?.bind(object)
        cell?.vc = self.vc
        cell?.indexPath = indexPath.row
        cell?.userID = object.id ?? 0
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
                    interstitial.present(fromRootViewController: vc!)
                    interstitial = CreateAd()
                    AppInstance.instance.addCount = 0
            }
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        self.mediaFiles.removeAll()
        let userObject = object[indexPath.row]
        
        let vc = R.storyboard.main.showUserDetailsVC()
        
        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText:userObject.countryText ??  "", relationshipText: userObject.relationshipText ??  "", bodyText: userObject.bodyText ??  "", smokeText: userObject.smokeText ?? "", ethnicityText:userObject.ethnicityText ?? "" , petsText:userObject.petsText ??  "", genderText:userObject.genderText ??  "", about: "", isFriend: false, isFavourite: false, is_friend_request: false)
        
//        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender:  "", countryText:userObject.countryText ??  "", relationshipText: userObject.relationshipText ??  "", bodyText: userObject.bodyText ??  "", smokeText: userObject.smokeText ?? "", ethnicityText:userObject.ethnicityText ?? "" , petsText:userObject.petsText ??  "", genderText:userObject.genderText ??  "", about: "")
        vc?.object = object
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width - 10, height: self.frame.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//    }
}
