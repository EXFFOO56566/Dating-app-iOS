//
//  UserImagesCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserImagesCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var mediaFiles = [String]()
    var vc:UIViewController?
    var baseVC:BaseVC?
    var object:ShowUserProfileModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(R.nib.showUserDetailsCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.showUserDetailsCollectionItem.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mediaFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.showUserDetailsCollectionItem.identifier, for: indexPath) as? ShowUserDetailsCollectionItem
        let  object = self.mediaFiles[indexPath.row]
        cell?.bind(object)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.mediaFiles[indexPath.row]
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(identifier: "ShowImageVC") as! ShowImageController
        vc.imageUrl = index
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let index = self.mediaFiles[indexPath.row]
    //        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let vc = Storyboard.instantiateViewController(identifier: "ShowImageVC") as! ShowImageController
    //        vc.imageUrl = index
    //        vc.modalTransitionStyle = .coverVertical
    //        vc.modalPresentationStyle = .fullScreen
    //        self.vc?.present(vc, animated: true, completion: nil)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
}
