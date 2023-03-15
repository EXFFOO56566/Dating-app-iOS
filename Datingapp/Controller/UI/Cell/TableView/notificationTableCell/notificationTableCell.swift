//
//  notificationTableCell.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/3/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class notificationTableCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.circleView()
        self.notifyTypeIcon.circleView()
        self.notifyTypeIcon.backgroundColor = .Main_StartColor
    }
    
    func bind(_ object:NotificationModel.Datum,Type:String){
        if Type == "got_new_match"{
            self.notifyTypeIcon.backgroundColor = .Main_StartColor
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text = NSLocalizedString("You got a new match, click to view!", comment: "You got a new match, click to view!")
        }else if Type == "visit"{
            notifyTypeIcon.image = UIImage(named: "small_visits_ic")
            notifyContentLabel.text = NSLocalizedString("Visit you", comment: "Visit you")
            
            self.notifyTypeIcon.backgroundColor = .Main_StartColor
            
        }else if Type == "like"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text = NSLocalizedString("Like you", comment: "Like you")
           self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }else if Type == "dislike"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text = NSLocalizedString("Dislike you", comment: "Dislike you")
            self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }else if Type == "friend_request_accepted"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text = NSLocalizedString("Is now in your friend list", comment: "Is now in your friend list")
           self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }else if Type == "friend_request"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text = NSLocalizedString("Requested to be a friend with you", comment: "Requested to be a friend with you")
          self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }
        
        if let avatarURL = URL(string: object.notifier?.avater ?? "") {
            avatarImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            avatarImageView.image = UIImage(named: "no_profile_image")
        }
        self.userLabel.text = object.notifier?.firstName ?? ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
