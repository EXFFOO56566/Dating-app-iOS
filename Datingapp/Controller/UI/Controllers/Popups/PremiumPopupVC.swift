//
//  PremiumPopupVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class PremiumPopupVC: UIViewController {
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    private func setupUI(){
        
        self.topLabel.text = NSLocalizedString("You are Premium User", comment: "You are Premium User")
         self.expirationDateLabel.text = NSLocalizedString("Lifetime", comment: "Lifetime")
        self.skipBtn.setTitle(NSLocalizedString("Skip", comment: "Skip"), for: .normal)
        
//        self.expirationDateLabel.text  = "Expiration Date : \(getDate(unixdate: Int(AppInstance.instance.userProfile?.data?.proTime ?? "0")! , timezone: "GMT"))"
       
        
    }
    override func viewDidLayoutSubviews() {
           bgView.setGradientBackground(colorOne: UIColor.Main_StartColor, colorTwo: UIColor.Main_EndColor, horizontal: true)
      }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "Updated: \(dateString)"
    }
    
    
    @IBAction func skipPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
