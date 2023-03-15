//
//  NotificationVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/3/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import QuickdateSDK
import JGProgressHUD
import Async

class NotificationVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var Notificationlabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var hud : JGProgressHUD?
    var listMatches: [NotificationModel.Datum] = []
    var listVisits: [NotificationModel.Datum] = []
    var listLikes: [NotificationModel.Datum] = []
    var friendRequest: [NotificationModel.Datum] = []
    
    
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        topView.setGradientBackground(colorOne: UIColor(red: 220/255, green: 34/255, blue: 80/255, alpha: 1.0), colorTwo: UIColor(red: 139/255, green: 46/255, blue: 128/255, alpha: 1.0), horizontal: true)
        self.fetchNotification()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    private func setupUI(){
        self.Notificationlabel.text = NSLocalizedString("Notifications", comment: "Notifications")
        
        
        let lineColor = UIColor.Main_StartColor
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = lineColor
        settings.style.buttonBarItemFont = UIFont(name: "Poppins-Light", size: 19)!
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        let color = UIColor(red:26/255, green: 34/255, blue: 78/255, alpha: 0.4)
        let newCellColor = UIColor.Main_StartColor
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .systemGray
            newCell?.label.textColor = newCellColor
            print("OldCell",oldCell)
            print("NewCell",newCell)
        }
    }
    private func fetchNotification(){
        self.showProgressDialog(text: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                NotificationManager.instance.getNotifications(AccessToken: accessToken, Limit: 0, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                success?.data?.forEach({ (it) in
                                    if it.type == "got_new_match"{
                                        self.listMatches.append(it)
                                    }else if it.type == "visit"{
                                        self.listVisits.append(it)
                                    }else if it.type == "like"{
                                        self.listLikes.append(it)
                                    }else if it.type == "dislike"{
                                        self.listLikes.append(it)
                                    }else if it.type == "friend_request_accepted"{
                                        self.friendRequest.append(it)
                                    }else if it.type == "friend_request"{
                                        self.friendRequest.append(it)
                                    }
                                })
                                self.reloadPagerTabStripView()
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
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            print("New index: \(toIndex)")
            if(toIndex==0){
                topView.setGradientBackground(colorOne: UIColor(red: 220/255, green: 34/255, blue: 80/255, alpha: 1.0), colorTwo: UIColor(red: 139/255, green: 46/255, blue: 128/255, alpha: 1.0), horizontal: true)
                log.verbose("Haris")
            }
            else{
                topView.setGradientBackground(colorOne: UIColor.Main_StartColor, colorTwo: UIColor.Main_EndColor, horizontal: true)
            }
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let matchesVC = R.storyboard.main.matchesVC()
        matchesVC?.listMatches = self.listMatches
        let visitsVC = R.storyboard.main.visitsVC()
        visitsVC?.listVisits = self.listVisits
        let likesVC = R.storyboard.main.likesVC()
        likesVC?.listLikes = self.listLikes
        let requestVC = R.storyboard.main.requestVC()
        requestVC?.friendRequest = self.friendRequest
        return [matchesVC!,visitsVC!,likesVC!,requestVC!]
    }
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = text
        hud?.show(in: self.view)
    }
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
}
