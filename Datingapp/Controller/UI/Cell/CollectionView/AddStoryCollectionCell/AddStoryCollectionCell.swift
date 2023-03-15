
import UIKit

class AddStoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.circleView()
        profileImage.borderColorV = .Main_StartColor
    }
    func bind(_ object:String){
           let url = URL(string: object)
           self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
       }

}
