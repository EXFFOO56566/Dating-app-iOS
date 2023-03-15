//
//  DislikeUsersVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork


class  DislikeUsersVC: BaseVC, FBInterstitialAdDelegate {

    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var noFavImage: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var peopleIDislikeLabel: UILabel!
    var dislikeUsers: [LikeDislikeModel.Datum] = []
      var mediaFiles = [String]()
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
        self.peopleIDislikeLabel.text = NSLocalizedString("People i Disliked", comment: "People i Disliked")
        self.noFavLabel.text = NSLocalizedString("There is no Disliked User", comment: "There is no Disliked User")
        collectionView.register(R.nib.peopleIDislikeCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.peopleIDislikeCollectionItem.identifier)
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
    
    
    //MARK: - Methods
    private func listFiend(){
        self.showProgressDialog(text: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                
                LikeDislikeMananger.instance.getDislikePeople(AccessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.dismissProgressDialog {
                                self.dislikeUsers = success?.data ?? []
                                if self.dislikeUsers.isEmpty{
                                    self.noFavImage.isHidden = false
                                    self.noFavLabel.isHidden = false
                                }else{
                                    self.noFavImage.isHidden = true
                                    self.noFavLabel.isHidden = true
                                    self.collectionView.reloadData()
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
    func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
        
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)
        
        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }
                        
                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DislikeUsersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dislikeUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.peopleIDislikeCollectionItem.identifier, for: indexPath) as! PeopleIDislikeCollectionItem
        let object = self.dislikeUsers[indexPath.row]
        
        cell.vc = self
        cell.bind(object, index: indexPath.row)
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
         let userObject = dislikeUsers[indexPath.row]
         for item in userObject.userData!.mediafiles!{
             self.mediaFiles.append(item.full ?? "")
         }
         let vc = R.storyboard.main.showUserDetailsVC()
    let object = ShowUserProfileModel(id: Int(userObject.userData?.id ?? "0")!, online: Int(userObject.userData?.online ?? "0")!, lastseen: Int(userObject.userData?.lastseen ?? "0"), username: userObject.userData?.username ?? "", avater: userObject.userData?.avater ?? "", country: userObject.userData?.country ?? "", firstName: userObject.userData?.firstName ?? "", lastName: userObject.userData?.lastName ?? "", location: userObject.userData?.location ?? "", birthday: userObject.userData?.birthday ?? "", language: userObject.userData?.language, relationship:Int(userObject.userData?.relationship ?? "0"), height: userObject.userData?.height ?? "", body: Int(userObject.userData?.body ?? "0"), smoke: Int(userObject.userData?.smoke ?? "0"), ethnicity: Int(userObject.userData?.ethnicity ?? "0"), pets: Int(userObject.userData?.pets ?? "0"), gender: userObject.userData?.gender ?? "", countryText: userObject.userData?.countryTxt ?? "", relationshipText: userObject.userData?.relationshipTxt ?? "", bodyText: userObject.userData?.bodyTxt ?? "", smokeText: userObject.userData?.smokeTxt ?? "", ethnicityText: userObject.userData?.ethnicityTxt ?? "", petsText: userObject.userData?.pets ?? "", genderText: userObject.userData?.genderTxt ?? "", about: userObject.userData?.about, isFriend: false, isFavourite: false, is_friend_request: false)
//    let object = ShowUserProfileModel(id: Int(userObject.userData?.id ?? "0")!, online: Int(userObject.userData?.online ?? "0")!, lastseen: Int(userObject.userData?.lastseen ?? "0"), username: userObject.userData?.username ?? "", avater: userObject.userData?.avater ?? "", country: userObject.userData?.country ?? "", firstName: userObject.userData?.firstName ?? "", lastName: userObject.userData?.lastName ?? "", location: userObject.userData?.location ?? "", birthday: userObject.userData?.birthday ?? "", language: userObject.userData?.language, relationship:Int(userObject.userData?.relationship ?? "0"), height: userObject.userData?.height ?? "", body: Int(userObject.userData?.body ?? "0"), smoke: Int(userObject.userData?.smoke ?? "0"), ethnicity: Int(userObject.userData?.ethnicity ?? "0"), pets: Int(userObject.userData?.pets ?? "0"), gender: userObject.userData?.gender ?? "", countryText: userObject.userData?.countryTxt ?? "", relationshipText: userObject.userData?.relationshipTxt ?? "", bodyText: userObject.userData?.bodyTxt ?? "", smokeText: userObject.userData?.smokeTxt ?? "", ethnicityText: userObject.userData?.ethnicityTxt ?? "", petsText: userObject.userData?.pets ?? "", genderText: userObject.userData?.genderTxt ?? "", about: userObject.userData?.about)
         vc?.mediaFiles = mediaFiles
         vc?.object = object
         self.navigationController?.pushViewController(vc!, animated: true)
     }
}
