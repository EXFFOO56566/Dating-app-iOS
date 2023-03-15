//
//  OnlineUserCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class OnlineUserCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.borderColorV = .Main_StartColor
    }
    func bind(_ object:TrendingModel.Datum){
        self.usernameLabel.text = object.username ?? ""
        let url = URL(string: object.avater ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
