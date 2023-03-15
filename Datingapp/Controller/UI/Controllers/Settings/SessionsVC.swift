//
//  SessionsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

import Async
import SwiftEventBus
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork

class SessionsVC: BaseVC, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sessionLabel: UILabel!
    private  var refreshControl = UIRefreshControl()
    var sessionArray = [SessionModel.Datum]()
    var interstitial: GADInterstitialAd!
    private var fetchSatus:Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
    }
    
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    func setupUI(){
        self.sessionLabel.text = NSLocalizedString("Session", comment: "Session")
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = "Manage Sessions"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.sessionTableItem(), forCellReuseIdentifier: R.reuseIdentifier.sessionTableItem.identifier)
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(text: "Loading...")
        }else{
            log.verbose("will not show Hud more...")
        }
        
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            SessionManager.instance.getSession(AccessToken: accessToken) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if (success?.data?.isEmpty)!{
                                self.refreshControl.endRefreshing()
                            }else {
                                
                                self.sessionArray = (success?.data) ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
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
        
    }
    
}
extension SessionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


extension SessionsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.sessionTableItem.identifier) as! SessionTableItem
        cell.vc = self
        let object = self.sessionArray[indexPath.row]
        cell.bind(object, index: indexPath.row)
        
        return cell
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
    }
   
}
