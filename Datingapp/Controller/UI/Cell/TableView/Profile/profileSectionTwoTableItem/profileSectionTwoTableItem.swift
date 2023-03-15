//
//  profileSectionTwoTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/11/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
class profileSectionTwoTableItem: UITableViewCell {

    @IBOutlet var itemIconImage: UIImageView!
    @IBOutlet var labelItemTitle: UILabel!
    @IBOutlet var labelItemInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
