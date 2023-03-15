//
//  UserSocialLinkCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserSocialLinkCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var socialInfoLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var userSocialData = [[String:Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib(nibName: "SocialInfoCell", bundle: nil), forCellWithReuseIdentifier: "SocialInfoCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(data:[String:Any]){
        var google = ""
        var facebook = ""
        var insta = ""
        var web = ""
        if let facebok = data["facebook"] as? String{
            facebook = facebok
        }
        if let googles = data["google"] as? String{
            google = googles
        }
        if let instagram = data["instagram"] as? String{
            insta = instagram
        }
        if let webs = data["website"] as? String{
            web = webs
        }
//        let datas = [["google":google],["facebook":facebook],["instagram":insta],["website":web]]
        if (self.userSocialData.isEmpty == true){
        if google != ""{
            self.userSocialData.append(["google":google])
        }
        if facebook != ""{
            self.userSocialData.append(["facebook":facebook])
        }
        if insta != ""{
            self.userSocialData.append(["instagram":insta])
        }
        if web != ""{
            self.userSocialData.append(["website":web])
        }
    }
        self.collectionView.reloadData()
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userSocialData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialInfoCell", for: indexPath) as! SocialInfoCell
        let index = self.userSocialData[indexPath.row]
        if let face = index["facebook"] as? String{
            cell.SocialImage.image = UIImage(named: "facebooks")
            cell.roundViews.borderColor = .blue
        }
        if let google = index["google"] as? String{
            cell.SocialImage.image = UIImage(named: "google-glas")
            cell.roundViews.borderColor = .brown
        }
        if let insta = index["instagram"] as? String{
            cell.SocialImage.image = UIImage(named: "instagramss")
            cell.roundViews.borderColor = .magenta
        }
        if let web = index["website"] as? String{
            cell.SocialImage.image = UIImage(named: "world")
            cell.roundViews.borderColor = .gray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.userSocialData[indexPath.item]
        if let face = index["facebook"] as? String{
            let link = face
            let url = URL(string: "\("https://www.facebook.com/")\(link)")
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.open(url!)

             } else {
                if let url = URL(string: "\("https://www.facebook.com/")\(link)") {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  }
            }
        }
        if let google = index["google"] as? String{
            let link = google
            let url = URL(string: link)
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.openURL(url!)

             } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.shared.openURL(NSURL(string: "www.google.com") as! URL)
            }
        }
        if let insta = index["instagram"] as? String{
            let link = insta
            let url = URL(string: link)
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.openURL(url!)

             } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.shared.openURL(NSURL(string: "www.google.com") as! URL)
            }
        }
        
        if let web = index["website"] as? String{
            let link = web
            if let url = URL(string: link) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
            
        }
        

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
}
