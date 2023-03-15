//
//  BuyCreditSectionOneCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/11/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class BuyCreditSectionOneCollectionItem: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
     @IBOutlet weak var itemText: UILabel!
     @IBOutlet weak var viewImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(_ object:dataSet){
        self.bgView.circleView()
        self.bgView.backgroundColor = object.bgColor
        self.itemText.text = object.title ?? ""
        self.viewImage.image = object.bgImage
    }

}
