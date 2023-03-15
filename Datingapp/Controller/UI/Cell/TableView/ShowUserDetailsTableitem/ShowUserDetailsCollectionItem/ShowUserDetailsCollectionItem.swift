//
//  ShowUserDetailsCollectionItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/21/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class ShowUserDetailsCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ object:String?){
        let url = URL(string: object ?? "")
        self.showImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
