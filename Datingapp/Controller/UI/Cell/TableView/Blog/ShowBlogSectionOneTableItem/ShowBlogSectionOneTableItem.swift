//
//  ShowBlogSectionOneTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class ShowBlogSectionOneTableItem: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object:BlogsModel.Datum){
        self.titleLabel.text = object.title?.htmlAttributedString ?? ""
        let url = URL(string: object.thumbnail ?? "")
               self.thumbImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
