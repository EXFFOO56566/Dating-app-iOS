//
//  DashboardVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 8/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Shuffle_iOS
import Async
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork

class DashboardVC: BaseVC, FBInterstitialAdDelegate{
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var filterPressed: UIButton!
    @IBOutlet weak var swipeCardStack: SwipeCardStack!
    @IBOutlet weak var bottonStackView: UIView!
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    
    var users: [GetMatchModel.Datum] = []
    var likedUserID = [Int]()
    var dislikedUserID = [Int]()
    var dislikeIdString:String = ""
    var likeIdString:String = ""
    var genderString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterPressed.tintColor = UIColor.Button_StartColor
        
        let showHideBool = UserDefaults.standard.getShowHideView(Key: "showHide")
            if showHideBool {
                self.fetchData(gender: "")
            }else{
                let vc = R.storyboard.popUps.tutorialViewVC()
                vc?.delegate = self
                self.present(vc!, animated: true, completion: nil)
            }
        swipeCardStack.delegate = self
        swipeCardStack.dataSource = self
        configureBackgroundGradient()
//           if ControlSettings.shouldShowAddMobBanner{
//
//                    bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//                    addBannerViewToView(bannerView)
//                    bannerView.adUnitID = ControlSettings.addUnitId
//                    bannerView.rootViewController = self
//                    bannerView.load(GADRequest())
//                    interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//                    let request = GADRequest()
//                    interstitial.load(request)
//                }
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
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
          func addBannerViewToView(_ bannerView: GADBannerView) {
              bannerView.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(bannerView)
              view.addConstraints(
                  [NSLayoutConstraint(item: bannerView,
                                      attribute: .bottom,
                                      relatedBy: .equal,
                                      toItem: bottomLayoutGuide,
                                      attribute: .top,
                                      multiplier: 1,
                                      constant: 0),
                   NSLayoutConstraint(item: bannerView,
                                      attribute: .centerX,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: .centerX,
                                      multiplier: 1,
                                      constant: 0)
                  ])
          }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func filterPressed(_ sender: Any) {
        
        let alert = UIAlertController(title:NSLocalizedString("Gender", comment: "Gender"), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let male = UIAlertAction(title:NSLocalizedString("Male", comment: "Male") , style: .default) { (action) in
            let male = AppInstance.instance.settings?.gender![0]
            for i in male!.keys{
                self.fetchData(gender: i)
            }
        }
        let female = UIAlertAction(title:NSLocalizedString("Female", comment: "Female") , style: .default) { (action) in
            let female = AppInstance.instance.settings?.gender![1]
            for i in female!.keys{
                self.fetchData(gender: i)
            }
        }
        let defaultSelect = UIAlertAction(title: NSLocalizedString("Defualt", comment: "Defualt"), style: .default) { (action) in
            self.fetchData(gender: "")
        }
        
        let cancel = UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(defaultSelect)
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func boostPressed(_ sender: Any) {
        let vc = R.storyboard.main.boostVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        self.users.removeAll()
        self.swipeCardStack.reloadData()
        self.fetchData(gender: "")
    }
    @IBAction func dislikePressed(_ sender: Any) {
        swipeCardStack.swipe(.left, animated: true)
    }
    @IBAction func likePressed(_ sender: Any) {
        swipeCardStack.swipe(.right, animated: true)
    }
    private func configureBackgroundGradient() {
        let backgroundGray = UIColor(red: 244 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func fetchData(gender:String){
        if Connectivity.isConnectedToNetwork(){
            self.users.removeAll()
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                GetMatchesManager.instance.getMatches(AccessToken: accessToken, Limit: 20, Offset: 0, genders: gender, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                                self.users = success?.data ?? []
                                self.swipeCardStack.reloadData()
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
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    private func likeDislikeMatch(likeString:String,disLikeString:String){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                LikesManager.instance.likeMatches(AccessToken: accessToken, LikesIdString: likeString, DisLikesIdString: disLikeString, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.dismissProgressDialog {
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
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
extension DashboardVC:SwipeCardStackDataSource,SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        for direction in card.swipeDirections {
            card.setOverlay(TinderCardOverlay(direction: direction), forDirection: direction)
        }
        let model = users[index]
        let url = URL(string: model.avater ?? "")
        
        Async.background({
            let data = try? Data(contentsOf: url!)
            Async.main({
                card.content = TinderCardContentView(withImage: UIImage(data: data!))
            })
        })
        card.footer = TinderCardFooterView(withTitle: "\(model.firstName ?? "") \(model.lastName ?? "")", subtitle:model.location ?? "")
        
        return card
    }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        let user = users[index]
        if direction == SwipeDirection.left{ //dislike
            dislikedUserID.append(user.id ?? 0)
            log.verbose("dislikedUserID = \(dislikedUserID)")
            if self.dislikedUserID.count == 10{
                
                var disLikeStringArray = self.dislikedUserID.map { String($0) }
                self.dislikeIdString = disLikeStringArray.joined(separator: ",")
                log.verbose("self.dislikeIdString = \(self.dislikeIdString)")
                
                var likeStringArray = self.likedUserID.map { String($0) }
                self.likeIdString = likeStringArray.joined(separator: ",")
                log.verbose("self.likeIdString = \(self.likeIdString)")
                
                self.likeDislikeMatch(likeString: self.likeIdString, disLikeString: dislikeIdString)
                self.dislikedUserID.removeAll()
                
            }
            
        } else if direction == SwipeDirection.right  { //like
            likedUserID.append(user.id ?? 0)
            log.verbose("likedUserID = \(likedUserID)")
            if self.likedUserID.count == 10{
                var disLikeStringArray = self.dislikedUserID.map { String($0) }
                self.dislikeIdString = disLikeStringArray.joined(separator: ",")
                log.verbose("self.dislikeIdString = \(self.dislikeIdString)")
                
                var likeStringArray = self.likedUserID.map { String($0) }
                self.likeIdString = likeStringArray.joined(separator: ",")
                log.verbose("self.likeIdString = \(self.likeIdString)")
                
                self.likeDislikeMatch(likeString: self.likeIdString, disLikeString: dislikeIdString)
                self.likedUserID.removeAll()
                
            }
        }
        
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return users.count
    }
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
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
        let vc = R.storyboard.main.showUserDetailsVC()
        let userObject = users[index]
        
        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender: userObject.gender ?? "", countryText: userObject.countryText ?? "", relationshipText: userObject.relationshipText ?? "", bodyText: userObject.bodyText ?? "", smokeText: userObject.smokeText ?? "", ethnicityText: userObject.ethnicityText ?? "", petsText: userObject.petsText ?? "", genderText: userObject.genderText ?? "", about: "", isFriend: false, isFavourite: false, is_friend_request: false)
        
//        let object = ShowUserProfileModel(id: userObject.id ?? 0, online: userObject.online ?? 0, lastseen: userObject.lastseen ?? 0, username: userObject.username ?? "", avater: userObject.avater ?? "", country: userObject.country ?? "", firstName: userObject.firstName ?? "", lastName: userObject.lastName ?? "", location: userObject.location ?? "", birthday: userObject.birthday ?? "", language: userObject.language, relationship:userObject.relationship ?? 0, height: userObject.height ?? "", body: userObject.body ?? 0, smoke: userObject.smoke ?? 0, ethnicity: userObject.ethnicity ?? 0, pets: userObject.pets ?? 0, gender: userObject.gender ?? "", countryText: userObject.countryText ?? "", relationshipText: userObject.relationshipText ?? "", bodyText: userObject.bodyText ?? "", smokeText: userObject.smokeText ?? "", ethnicityText: userObject.ethnicityText ?? "", petsText: userObject.petsText ?? "", genderText: userObject.genderText ?? "", about: "")
        vc!.object = object 
      self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension DashboardVC:dismissTutorialViewDelegate{
    func dismissTutorialView(status: Bool) {
        self.fetchData(gender: "")
    }
}
