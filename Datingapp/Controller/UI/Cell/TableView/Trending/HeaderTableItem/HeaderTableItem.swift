//
//  HeaderTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class HeaderTableItem: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewMoreBtn: UIButton!
    var vc:TrendingVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewMorePressed(_ sender: Any) {
        let vc = R.storyboard.trending.hotOrNotVC()
        vc?.hotOrNotArray = self.vc!.hotOrNotUsers
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
}
