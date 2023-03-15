

import UIKit
import QuickdateSDK
class StickersViewController: UIViewController {
    
    private var stickersArray = [StickerModel.Datum]()
    private var giftsArray = [GiftModel.Datum]()
    var stickerDelegate:didSelectStickerDelegate!
    var giftDelegate:didSelectGiftDelegate!
    var checkStatus:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if checkStatus!{
            var allGiftsData =  UserDefaults.standard.getGifts(Key: Local.GIFTS.Gifts)
            let gifts = try? PropertyListDecoder().decode([GiftModel.Datum].self ,from: allGiftsData)
            self.giftsArray = gifts ?? []
            log.verbose("AllData for gift = \(gifts)")
        }else{
            var allStickersData =  UserDefaults.standard.getStickers(Key: Local.STICKERS.Stickers)
            let stickers = try? PropertyListDecoder().decode([StickerModel.Datum].self ,from: allStickersData)
            self.stickersArray = stickers ?? []
            log.verbose("AllData for stickers = \(stickers)")
        }
        
        
    }
}

extension StickersViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if checkStatus!{
            return self.giftsArray.count
        }else{
            return self.stickersArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerAndGiftCollectionCellID", for: indexPath) as? StickerAndGiftCollectionCell
        if checkStatus!{
            let object = self.giftsArray[indexPath.row]
            let url = URL(string: object.file ?? "")
            cell?.stickerAndGiftImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        }else{
            let object = self.stickersArray[indexPath.row]
            let url = URL(string: object.file ?? "")
            cell?.stickerAndGiftImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkStatus!{
            self.giftDelegate.selectGift(giftId: self.giftsArray[indexPath.row].id ?? 0)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.stickerDelegate.selectSticker(stickerId: self.stickersArray[indexPath.row].id ?? 0)
            self.dismiss(animated: true, completion: nil)
        }
       
    }
}
