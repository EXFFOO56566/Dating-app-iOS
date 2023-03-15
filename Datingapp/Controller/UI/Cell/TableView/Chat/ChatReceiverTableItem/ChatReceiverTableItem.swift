//
//  ChatReceiverTableItem.swift
//  DeepSoundiOS
//
//  Created by Muhammad Haris Butt on 6/21/20.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.
//

import UIKit

class ChatReceiverTableItem: UITableViewCell {

    @IBOutlet weak var cornerImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = .Main_StartColor
              self.cornerImage.tintColor = .Main_StartColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bind(_ object:GetChatConversationModel.Datum){
          self.titleLabel.text = object.text ?? ""
        self.dateLabel.text = self.getDate(unixdate: object.seen ?? 0, timezone: "GMT")
          
      }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
            if unixdate == 0 {return ""}
            let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "h:mm a"
            dayTimePeriodFormatter.timeZone = .current
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return "\(dateString)"
        }
}
