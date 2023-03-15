//
//  BuyCreditSectionTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/11/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class BuyCreditSectionTableItem: UITableViewCell {
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!

    var dataSetArray = [dataSet]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.collectionView.isPagingEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func setupUI(){
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.Main_StartColor, UIColor.Main_EndColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.bgView.frame.size.width, height: self.bgView.frame.size.height)

        self.bgView.layer.insertSublayer(gradient, at: 0)
        
//
//        self.bgView.setGradientBackground(colorOne: .Main_StartColor, colorTwo: .Main_StartColor, horizontal: true)
        self.topLabel.text = NSLocalizedString("Your Quickdate Credits balance", comment: "Your Quickdate Credits balance")
        
        self.bgView.circleView()
        self.creditLabel.text = "\(AppInstance.instance.userProfile?.data?.balance ?? "") \(NSLocalizedString("Credits", comment: "Credits"))"
        self.dataSetArray = [
            dataSet(title:NSLocalizedString("Boost your profile", comment: "Boost your profile") , bgColor: .blue, bgImage: R.image.rocket_ic()),
            dataSet(title:NSLocalizedString("Highlight your messages", comment: "Highlight your messages"), bgColor: .blue, bgImage: R.image.ic_chat()),
            dataSet(title: NSLocalizedString("send a gift", comment: "send a gift"), bgColor: .orange, bgImage: R.image.ic_gift()),
            dataSet(title: NSLocalizedString("Get seen 100x in Discover", comment: "Get seen 100x in Discover"), bgColor: .green, bgImage: R.image.viewPager_target()),
            dataSet(title: NSLocalizedString("Put your self First in Search", comment: "Put your self First in Search"), bgColor: .purple, bgImage: R.image.viewPager_crown()),
            dataSet(title: NSLocalizedString("Get additional Stickers", comment: "Get additional Stickers"), bgColor: .green, bgImage: R.image.viewPager_sticker()),
            dataSet(title: NSLocalizedString("Double your chances for a friendship", comment: "Double your chances for a friendship"), bgColor: .red, bgImage: R.image.viewPager_heart())
        ]
        collectionView.register(R.nib.buyCreditSectionOneCollectionItem(), forCellWithReuseIdentifier: R.reuseIdentifier.buyCreditSectionOneCollectionItem.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
}
extension BuyCreditSectionTableItem:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageView.numberOfPages = self.dataSetArray.count
        return self.dataSetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.buyCreditSectionOneCollectionItem.identifier, for: indexPath) as? BuyCreditSectionOneCollectionItem
        let object = dataSetArray[indexPath.row]
        cell!.bind(object)
        return cell!
    }
}
extension BuyCreditSectionTableItem: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
