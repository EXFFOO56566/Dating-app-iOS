//
//  BoostVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Async
class BoostVC: BaseVC {
    var delegate:movetoPayScreenDelegate?
    @IBOutlet weak var rocketImage: UIImageView!
    
    @IBOutlet weak var heartimage: UIImageView!
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var topVIew: UIView!
    @IBOutlet weak var likesBtn: UIButton!
    @IBOutlet weak var matchesBtn: UIButton!
    @IBOutlet weak var visitsBtn: UIButton!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var popularitylabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var visitCreditLabel: UILabel!
    
    @IBOutlet weak var likesCreditLabel: UILabel!
    @IBOutlet weak var matchesCreditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
       
        
        self.topVIew.backgroundColor = .Main_StartColor
        self.matchesBtn.backgroundColor = .Button_StartColor
        self.matchesBtn.setTitleColor(.Button_TextColor, for: .normal)
        self.lowLabel.text = NSLocalizedString("Very Low", comment: "Very Low")
        self.popularitylabel.text = NSLocalizedString("Your Popularity", comment: "Your Popularity")
        self.visitLabel.text = NSLocalizedString("Promote your profile by get more visits, for 5 minutes", comment: "Promote your profile by get more visits, for 5 minutes")
        self.matchesLabel.text = NSLocalizedString("Show more and rise up at the same time, for 4 minutes", comment: "Show more and rise up at the same time, for 4 minutes")
        self.likesLabel.text = NSLocalizedString("Tell everyone you're online and be seen by users who want to chat, for 5 minutes", comment: "Tell everyone you're online and be seen by users who want to chat, for 5 minutes")
        
        self.visitsBtn.setTitle( NSLocalizedString("Get x10 Visits", comment: "Get x10 Visits"), for: .normal)
        self.matchesBtn.setTitle( NSLocalizedString("Get x3 Matches", comment: "Get x3 Matches"), for: .normal)
        self.likesBtn.setTitle( NSLocalizedString("Get x4 Likes", comment: "Get x4 Likes"), for: .normal)
        
        self.visitCreditLabel.text = NSLocalizedString("25 Credits", comment: "25 Credits")
        self.matchesCreditLabel.text = NSLocalizedString("35 Credits", comment: "25 Credits")
        self.likesCreditLabel.text = NSLocalizedString("45 Credits", comment: "25 Credits")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation(hide: false)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func getTenXVisitsPressed(_ sender: Any) {
        managedPopularity(type: "visits")
        
    }
    @IBAction func getx3MatchesPressed(_ sender: Any) {
        managedPopularity(type: "matches")
    }
    @IBAction func getx4LikesPressed(_ sender: Any) {
        managedPopularity(type: "likes")
        
    }
    private func managedPopularity(type:String){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                PopularityManager.instance.managePopularity(AccessToken: accessToken, Type: type, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                let vc = R.storyboard.credit.buyCreditVC()
                                      vc?.delegate = self
                                      self.present(vc!, animated: true, completion: nil)
                                
//                                self.navigationController?.popViewController(animated: true)
//                                if type == "visits"{
//                                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 25, description: "visits", membershipType: 0, credits: 25)
//                                }else if type == "matches"{
//                                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 35, description: "matches", membershipType: 0, credits: 35)
//
//                                }else if type == "likes"{
//                                    self.delegate?.moveToPayScreen(status: true, payType: "credits", amount: 45, description: "likes", membershipType: 0, credits: 45)
//                                }
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
extension BoostVC:movetoPayScreenDelegate{
    func moveToPayScreen(status: Bool, payType: String?, amount: Int, description: String,membershipType:Int?,credits:Int?) {
        if !status{
            let vc = R.storyboard.credit.bankTransferVC()
            vc?.payType = payType ?? ""
            vc?.amount = amount
            vc?.Description = description
            vc?.memberShipType = membershipType
            vc?.credits = credits ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = R.storyboard.credit.payVC()
            vc?.payType = payType ?? ""
            vc?.amount = amount
            vc?.Description = description
            vc?.memberShipType = membershipType
            vc?.credits = credits ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
       
    }
    
   
}
