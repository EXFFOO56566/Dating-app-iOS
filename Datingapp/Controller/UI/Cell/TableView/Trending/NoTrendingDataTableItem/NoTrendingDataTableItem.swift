//
//  NoTrendingDataTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 6/2/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class NoTrendingDataTableItem: UITableViewCell {
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noLabel.text = NSLocalizedString("There is no data to show", comment: "There is no data to show")
        self.noImage.tintColor = .Main_StartColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
