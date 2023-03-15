//
//  BlogViewTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 10/1/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class BlogViewTableItem: UITableViewCell {

    @IBOutlet weak var viewsLabel: UILabel!
    var vc:UIViewController?
    var shareLinkString:String? = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object:BlogsModel.Datum?){
        self.viewsLabel.text = NSLocalizedString("\(object?.view ?? 0) Views", comment: "\(object?.view ?? 0) Views")
        self.shareLinkString = object?.url ?? ""
    }
    
    @IBAction func moreBtn(_ sender: Any) {
        self.alertShow(URL: self.shareLinkString ?? "")
    }
    private func alertShow(URL:String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        var copyLink = UIAlertAction(title: NSLocalizedString("Copy Link", comment: "Copy Link"), style: .default) { (action) in
        UIPasteboard.general.string = URL
            self.vc?.view.makeToast(NSLocalizedString("Copy to clipboard", comment: "Copy to clipboard"))
        }
       var share = UIAlertAction(title: NSLocalizedString("Share", comment: "Share"), style: .default) { (action) in
        self.share(url: URL)
        }
        var cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(copyLink)
        alert.addAction(share)
        alert.addAction(cancel)
        self.vc?.present(alert, animated: true, completion: nil)
    }
    private func share(url:String){
        let myWebsite = NSURL(string:url)
               guard let url = myWebsite else {
                   print("nothing found")
                   return
               }
               let shareItems:Array = [ url]
               let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
               activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.vc?.present(activityViewController, animated: true, completion: nil)
    }
}
