//
//  UpgradeAccountCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UpgradeAccountCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func bind(_ object:UpgradeDataSetClass){
        self.planNameLabel.text = object.planName ?? ""
        self.moneyLabel.text = object.planMoney ?? ""
        self.planTypeLabel.text = object.planTyle ?? ""
        self.backgroundVIew.backgroundColor = object.planColor
    }
    
}
