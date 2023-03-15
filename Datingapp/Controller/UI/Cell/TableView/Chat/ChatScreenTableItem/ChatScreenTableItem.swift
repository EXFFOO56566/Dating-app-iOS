//
//  ChatScreenTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/4/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class ChatScreenTableItem: UITableViewCell {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var textMsgLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.circleView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object:GetConversationModel.Datum){
        
        self.textMsgLabel.text  = object.text ?? ""
        if object.user?.firstName == "" && object.user?.lastName  == ""{
            self.userNameLabel.text = object.user?.username ?? ""
        }else{
            self.userNameLabel.text =  "\(object.user?.firstName ?? "") \(object.user?.firstName ?? "")" ?? object.user?.username ?? ""
        }
        self.timeLabel.text = object.time ?? ""
        let url = URL(string: object.user?.avater ?? "")
        self.avatarImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        
        if object.messageType == "media"{
            self.textMsgLabel.text = "Photo"
            self.iconImage.isHidden = false
        }else if object.messageType == "sticker"{
            self.textMsgLabel.text = "sticker"
            self.iconImage.isHidden = false
        }else{
            self.textMsgLabel.text = object.text ?? ""
            self.iconImage.isHidden = true
            
        }
    }
    
}
