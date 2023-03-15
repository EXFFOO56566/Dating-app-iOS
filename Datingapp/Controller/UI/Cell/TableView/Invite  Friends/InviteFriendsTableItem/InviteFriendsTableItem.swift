//
//  InviteFriendsTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class InviteFriendsTableItem: UITableViewCell {
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topLabel.text = NSLocalizedString("Share The Love", comment: "Share The Love")
        
        self.bottomLabel.text = NSLocalizedString("Share it by inviting your friends using these", comment: "Share it by inviting your friends using these")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
