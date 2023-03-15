//
//  ChatVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/4/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds
import FBAudienceNetwork


class ChatVC: BaseVC, FBInterstitialAdDelegate {

    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var noMsgLabel: UILabel!
    @IBOutlet weak var noMsgImage: UIImageView!
    @IBOutlet var messagesTableView: UITableView!
    
    var messagesList: [GetConversationModel.Datum] = []
    var offset: Int = 0
    var interstitial: GADInterstitialAd!
    var interstitialAd1: FBInterstitialAd?

    
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
    
    
    
    private func setupUI(){
        self.noMsgImage.tintColor = .Main_StartColor
        self.chatLabel.text = NSLocalizedString("Chat", comment: "Chat")
        self.noMsgLabel.text  = NSLocalizedString("There are no messages", comment: "There are no messages")
        
        self.messagesTableView.separatorStyle = .none
        self.messagesTableView.register(R.nib.chatScreenTableItem(), forCellReuseIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
   
    //MARK: - Methods
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
           messagesList.removeAll()
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                ChatManager.instance.getConversation(AccessToken: accessToken, Limit: 20, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.data ?? [])")
                               
                                   self.messagesList = success?.data ?? []
                                
                                if self.messagesList.isEmpty{
                                    
                                    self.noMsgImage.isHidden = false
                                    self.noMsgLabel.isHidden = false
                                }else{
                                    self.noMsgImage.isHidden = true
                                    self.noMsgLabel.isHidden = true
                                  self.messagesTableView.reloadData()
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
                })
             
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    

}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier, for: indexPath) as! ChatScreenTableItem
      //  cell.avatarImageView.circleView()
        if messagesList.count == 0{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let object = self.messagesList[indexPath.row]
        cell.bind(object)
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
        if self.messagesList.count != 0{
                   let object = messagesList[indexPath.row]
                       let vc = R.storyboard.chat.chatScreenVC()
                       vc?.toUserId  = object.user?.id ?? ""
                       vc?.usernameString = object.user?.username ?? ""
                        vc?.lastSeenString =  object.user?.lastseen ?? ""
                       vc?.profileImageString = object.user?.avater ?? ""
                       self.navigationController?.pushViewController(vc!, animated: true)
            
        }else{
//            let object = messagesList[indexPath.row]
//                   let stb = UIStoryboard(name: "Chat", bundle: nil)
//                   let vc = R.storyboard.chat.chatViewController()
//                   vc?.toUserId  = object.user?.id ?? ""
//                   vc?.usernameString = object.user?.username ?? ""
//                    vc?.lastSeenString =  object.user?.lastseen ?? ""
//                   vc?.profileImageString = object.user?.avater ?? ""
//                   self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
