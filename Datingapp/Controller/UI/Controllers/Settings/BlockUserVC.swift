//
//  BlockUserVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
import GoogleMobileAds
import FBAudienceNetwork

class BlockUserVC: BaseVC, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var blockUserLabel: UILabel!
    @IBOutlet weak var noBlockLabel: UILabel!
    @IBOutlet weak var noBlockImage: UIImageView!
    @IBOutlet var blockedUsersTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        blockedUsersTableView.delegate = self
        blockedUsersTableView.dataSource = self
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")

            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    
    //MARK:- Methods
    private func setupUI(){
        noBlockImage.tintColor = UIColor.Main_StartColor
        self.blockUserLabel.text = NSLocalizedString("BLocked Users", comment: "BLocked Users")
        self.noBlockLabel.text = NSLocalizedString("There is no Blocked User", comment: "There is no Blocked User")
        if (AppInstance.instance.userProfile?.data?.blocks!.isEmpty)!{
            self.noBlockImage.isHidden = false
            self.noBlockLabel.isHidden = false
        }else{
            self.noBlockImage.isHidden = true
            self.noBlockLabel.isHidden = true
        }
        blockedUsersTableView.register(R.nib.blockUserTableItem(), forCellReuseIdentifier: R.reuseIdentifier.blockUserTableItem.identifier)
        
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
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private func ublockAlert(userID:String,index:Int){
        
        let alert = UIAlertController(title: "", message: "Unblock", preferredStyle: .actionSheet)
        let unBlock = UIAlertAction(title: "Unblock", style: .default) { (action) in
            self.unBlockUser(userId: userID, index: index)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(unBlock)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    private func unBlockUser(userId:String,index:Int){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = Int(userId ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                AppInstance.instance.userProfile?.data?.blocks?.remove(at: index)
                                self.blockedUsersTableView.reloadData()
                                
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

extension BlockUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppInstance.instance.userProfile?.data?.blocks!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blockUserTableItem.identifier, for: indexPath) as! BlockUserTableItem
        let object = AppInstance.instance.userProfile?.data?.blocks?[indexPath.row]
        cell.configView()
        cell.bind(object!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
        
        let object = AppInstance.instance.userProfile?.data?.blocks?[indexPath.row].data
        self.ublockAlert(userID: object?.id ?? "", index: indexPath.row)
    }
}

