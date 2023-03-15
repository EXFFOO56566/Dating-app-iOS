//
//  ReceiverImageTableItem.swift
//  DeepSoundiOS
//
//  Created by Muhammad Haris Butt on 6/21/20.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.
//

import UIKit

class ReceiverImageTableItem: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var cornerimage: UIImageView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = .Main_StartColor
        self.cornerimage.tintColor = .Main_StartColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object:GetChatConversationModel.Datum){
        if object.messageType == "media"{
            let thumbnailURL = URL.init(string:object.media ?? "")
                       self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
        }else{
            let thumbnailURL = URL.init(string:object.sticker ?? "")
            self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
           
        }
      
    }
    
}
