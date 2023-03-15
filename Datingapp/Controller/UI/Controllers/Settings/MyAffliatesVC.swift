//
//  MyAffliatesVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
class MyAffliatesVC: UIViewController {
    @IBOutlet weak var clickLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var myAffliatesLabel: UILabel!
    override func viewDidLoad() {
        shareBtn.setTitleColor(.Button_StartColor, for: .normal)
        shareBtn.borderColorV = .Button_StartColor
        super.viewDidLoad()
        self.myAffliatesLabel.text = NSLocalizedString("My Affliates", comment: "My Affliates")
        self.topLabel.text = NSLocalizedString("Earn upto $ for each user your refer to us!", comment: "Earn upto $ for each user your refer to us!")
        self.shareBtn.setTitle(NSLocalizedString("Share to", comment: "Share to"), for: .normal)
        
        
        self.clickLabel.text = "\(ControlSettings.baseURL)register?ref=\(AppInstance.instance.userProfile?.data?.username ?? "")"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
           clickLabel.isUserInteractionEnabled = true
           clickLabel.addGestureRecognizer(tap)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: "\(ControlSettings.baseURL)register?ref=\(AppInstance.instance.userProfile?.data?.username ?? "")")
    }
    
    @IBAction func shareToPressed(_ sender: Any) {
        self.shareAcitvity()
    }
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    func shareAcitvity(){
        let myWebsite = NSURL(string:"\(ControlSettings.baseURL)register?ref=\(AppInstance.instance.userProfile?.data?.username ?? "")")
        let shareAll = [ myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
