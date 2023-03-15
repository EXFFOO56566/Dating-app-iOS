//
//  HelpVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import WebKit
class HelpVC: BaseVC {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var helpLabel: UILabel!
    var checkString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpLabel.text = NSLocalizedString("Help", comment: "Help")
        hideNavigation(hide: true)
        initWebView()
        
    }
    
    //MARK: - Methods
    func initWebView() {
        if checkString == "help"{
            webView.navigationDelegate = self
            self.statusLabel.text = "Help"
            let url = URL(string: ControlSettings.HelpLink)
            let urlRequest = URLRequest(url: url!)
            
            webView.load(urlRequest)
        }else if checkString == "about"{
            self.statusLabel.text = "About"
            let url = URL(string: ControlSettings.aboutLink)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        }
        else if checkString == "terms"{
            self.statusLabel.text = "Terms And Condition"
            let url = URL(string: ControlSettings.Terms)
            let urlRequest = URLRequest(url: url!)
            webView.load(urlRequest)
        }
    }
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        if  checkString == "terms"{
            self.dismiss(animated: true, completion: nil)
        }else{
             navigationController?.popViewController(animated: true)
        }
       
    }
}

extension HelpVC:WKNavigationDelegate{
 func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    self.showProgressDialog(text: "Loading...")
    }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.dismissProgressDialog {
        log.verbose("dismissed")
    }
  }
}
