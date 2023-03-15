//
//  BuyCreditSectionTwoCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/11/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class BuyCreditSectionTwoCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add shadow on cell
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }
    
    func bind(_ object:dataSetTwo){
        self.ammountLabel.text = object.Credit
        self.chargeLabel.text = object.ammount
        self.titleLabel.text = object.title ?? ""
        self.itemImage.image = object.itemImage
    }
    
}
