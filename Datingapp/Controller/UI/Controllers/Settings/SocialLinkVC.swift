//
//  SocialLinkVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Toast
import Async
import QuickdateSDK
class SocialLinkVC: BaseVC {

    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var facebookText: UITextField!
    @IBOutlet var twitterText: UITextField!
    @IBOutlet var googleText: UITextField!
    @IBOutlet var instaText: UITextField!
    @IBOutlet var linkedInText: UITextField!
    @IBOutlet var websiteText: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideNavigation(hide: true)
        configView()
        self.setupUI()
    }
    
    //MARK:- Methods
    func configView() {
        saveButton.layer.cornerRadius = 8
    }
    private func setupUI(){
         self.saveButton.backgroundColor = .Button_StartColor
        
        self.socialLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
        self.facebookText.placeholder = NSLocalizedString("Facebook", comment: "Facebook")
        self.twitterText.placeholder = NSLocalizedString("Twitter", comment: "Twitter")
        self.googleText.placeholder = NSLocalizedString("Google Plus", comment: "Google Plus")
        self.instaText.placeholder = NSLocalizedString("Instagram", comment: "Instagram")
         self.linkedInText.placeholder = NSLocalizedString("LinkedIn", comment: "LinkedIn")
         self.websiteText.placeholder = NSLocalizedString("Website", comment: "Website")
        self.saveButton.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        self.facebookText.text = AppInstance.instance.userProfile?.data?.facebook ?? ""
        self.twitterText.text = AppInstance.instance.userProfile?.data?.twitter ?? ""
        self.googleText.text = AppInstance.instance.userProfile?.data?.google ?? ""
        self.instaText.text = AppInstance.instance.userProfile?.data?.instagram ?? ""
        self.linkedInText.text = AppInstance.instance.userProfile?.data?.linkedin ?? ""
        self.websiteText.text = AppInstance.instance.userProfile?.data?.website ?? ""
    }
    private func updateSocialLinks(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let facebook = self.facebookText.text ?? ""
            let twitter = self.twitterText.text ?? ""
            let google = self.googleText.text ?? ""
            let instagram = self.instaText.text ?? ""
            let linkdin = self.linkedInText.text ?? ""
            let website = self.websiteText.text ?? ""
            Async.background({
                ProfileManger.instance.updateSocialLinks(AccessToken: accessToken, facebook: facebook, twitter: twitter, google: google, instagram: instagram, linkedIn: linkdin, website: website, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                     log.debug("UPDATED")
                                })
                                
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
    
    
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
       updateSocialLinks()
    }
}
