//
//  VisitsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/3/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMobileAds
import FBAudienceNetwork

class VisitsVC: UIViewController, FBInterstitialAdDelegate {
    var itemInfo = IndicatorInfo(title: "View")
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var noLabel: UIStackView!
    @IBOutlet weak var noNotificationDetaillabel: UILabel!
    @IBOutlet weak var noNotificationLabel: UILabel!
    
    var listVisits: [NotificationModel.Datum] = []
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        self.noNotificationLabel.text = NSLocalizedString("No Notifications Yet", comment: "No Notifications Yet")
        self.noNotificationDetaillabel.text  = NSLocalizedString("We will display once you get your first activity here ", comment: "We will display once you get your first activity here ")
        if self.listVisits.isEmpty{
            self.noImage.isHidden = false
            self.noLabel.isHidden = false
        }else{
            self.noImage.isHidden = true
            self.noLabel.isHidden = true
        }
        tableVIew.separatorStyle = .none
        tableVIew.register( R.nib.notificationTableCell(), forCellReuseIdentifier: R.reuseIdentifier.notificationTableCell.identifier)
        self.tableVIew.reloadData()
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
    
}
extension VisitsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationTableCell.identifier) as? notificationTableCell
        cell?.selectionStyle = .none
        let object = self.listVisits[indexPath.row]
        cell?.bind(object, Type: object.type ?? "")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let userObject = listVisits[indexPath.row]
        
        let vc = R.storyboard.main.showUserDetailsVC()
        
        let object = ShowUserProfileModel(id: userObject.notifier?.id ?? 0, online: userObject.notifier?.online ?? 0, lastseen: userObject.notifier?.lastseen ?? 0, username: userObject.notifier?.username ?? "", avater: userObject.notifier?.avater ?? "", country: userObject.notifier?.country ?? "", firstName: userObject.notifier?.firstName ?? "", lastName: userObject.notifier?.lastName ?? "", location: userObject.notifier?.location ?? "", birthday: userObject.notifier?.birthday ?? "", language: userObject.notifier?.language, relationship:userObject.notifier?.relationship ?? 0, height: userObject.notifier?.height ?? "", body: userObject.notifier?.body ?? 0, smoke: userObject.notifier?.smoke ?? 0, ethnicity: userObject.notifier?.ethnicity ?? 0, pets: userObject.notifier?.pets ?? 0, gender: userObject.notifier?.gender ?? "", countryText: userObject.notifier?.country ?? "", relationshipText: "", bodyText:  "", smokeText:"" , ethnicityText:  "", petsText: "", genderText: userObject.notifier?.gender ?? "", about: userObject.notifier?.about ?? "", isFriend: false, isFavourite: false, is_friend_request: false)
        
//        let object = ShowUserProfileModel(id: userObject.notifier?.id ?? 0, online: userObject.notifier?.online ?? 0, lastseen: userObject.notifier?.lastseen ?? 0, username: userObject.notifier?.username ?? "", avater: userObject.notifier?.avater ?? "", country: userObject.notifier?.country ?? "", firstName: userObject.notifier?.firstName ?? "", lastName: userObject.notifier?.lastName ?? "", location: userObject.notifier?.location ?? "", birthday: userObject.notifier?.birthday ?? "", language: userObject.notifier?.language, relationship:userObject.notifier?.relationship ?? 0, height: userObject.notifier?.height ?? "", body: userObject.notifier?.body ?? 0, smoke: userObject.notifier?.smoke ?? 0, ethnicity: userObject.notifier?.ethnicity ?? 0, pets: userObject.notifier?.pets ?? 0, gender: userObject.notifier?.gender ?? "", countryText: userObject.notifier?.country ?? "", relationshipText: "", bodyText:  "", smokeText:"" , ethnicityText:  "", petsText: "", genderText: userObject.notifier?.gender ?? "", about: userObject.notifier?.about ?? "")
        
        vc?.object = object
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension VisitsVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: NSLocalizedString("Visits", comment: "Visits"))
    }
}
