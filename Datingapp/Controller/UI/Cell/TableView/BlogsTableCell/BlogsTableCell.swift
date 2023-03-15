

import UIKit

class BlogsTableCell: UITableViewCell {
    @IBOutlet weak var descriptionlabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryBg: UIView!
    @IBOutlet weak var blogCategoryLabel: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
