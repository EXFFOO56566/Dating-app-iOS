//
//  BlockUserTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/16/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class BlockUserTableItem: UITableViewCell {
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configView() {
        avatarImage.circleView()
    }
    func bind(_ object:UserProfileModel.Block){
        self.userNameLabel.text = object.data?.username ?? ""
        let url = URL(string: object.data?.avater ?? "")
        self.avatarImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
