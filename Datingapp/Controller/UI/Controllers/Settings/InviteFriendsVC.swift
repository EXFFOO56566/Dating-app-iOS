//
//  InviteFriendsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork

class InviteFriendsVC: BaseVC, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet var backButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var inviteFriendLabel: UILabel!
    
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setupUI()
        
    }
    
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    private func setupUI(){
        self.inviteFriendLabel.text = NSLocalizedString("Invite Friends", comment: "Invite Friends")
        tableView.register(R.nib.inviteFriendsTableItem(), forCellReuseIdentifier: R.reuseIdentifier.inviteFriendsTableItem.identifier)
        tableView.register( R.nib.inviteFriendsSecondTableItem(), forCellReuseIdentifier: R.reuseIdentifier.inviteFriendsSecondTableItem.identifier)
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
    
    // MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension InviteFriendsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriendsTableItem.identifier, for: indexPath) as! InviteFriendsTableItem
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriendsSecondTableItem.identifier, for: indexPath) as! InviteFriendsSecondTableItem
            cell.configView(row: indexPath.row)
            return cell
        }
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
        if indexPath.row == 1 {
            UIPasteboard.general.string = "\(ControlSettings.baseURL)@\(AppInstance.instance.userProfile?.data?.username ?? "")"
            self.view.makeToast("copy to clipboard ")
            
        } else if indexPath.row == 2 {
            self.share(stringURL: "\(ControlSettings.baseURL)@\(AppInstance.instance.userProfile?.data?.username ?? "")")
        }
    }
    private func share(stringURL:String){
        let someText:String = stringURL
        let objectsToShare:URL = URL(string: stringURL)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTencentWeibo]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
