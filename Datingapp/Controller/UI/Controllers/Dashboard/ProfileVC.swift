//
//  ProfileVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/11/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
class ProfileVC: BaseVC {
    
    @IBOutlet var profileTableView: UITableView!
    
    var items = [
        
        ["icon": "ic_friends", "title": NSLocalizedString("Friends", comment: "Friends"), "info": NSLocalizedString("Display all your friend users", comment: "Display all your friend users")],
        ["icon": "like", "title": NSLocalizedString("People i Liked", comment: "People i Liked"), "info": NSLocalizedString("Display Users i give them a like", comment: "Display Users i give them a like")],
        ["icon": "dislike", "title": NSLocalizedString("People i Disliked", comment: "People i Disliked"), "info":NSLocalizedString("Display users i didn't like", comment: "Display users i didn't like") ],
        ["icon": "fav_ic", "title": NSLocalizedString("Favorite", comment: "Favorite"), "info":NSLocalizedString("Display all your favorite users", comment: "Display all your favorite users")],
        ["icon": "blog_ic", "title": NSLocalizedString("Blogs", comment: "Blogs"), "info":  NSLocalizedString("Read the latest Articles", comment: "Read the latest Articles")],
        ["icon": "add_ic", "title":NSLocalizedString("Invite Friends", comment: "Invite Friends") , "info": NSLocalizedString("Invite Friends to the app", comment: "Invite Friends to the app")]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
    }
    
    private func setupUI(){
        self.profileTableView.separatorStyle = .none
        self.profileTableView.register(R.nib.profileSectionOneTableItem(), forCellReuseIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier)
        self.profileTableView.register(R.nib.profileSectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return items.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier, for: indexPath) as! ProfileSectionOneTableItem
            cell.vc = self
            cell.configView()
            cell.configData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier, for: indexPath) as! profileSectionTwoTableItem
            cell.itemIconImage.image = UIImage(named: items[indexPath.row]["icon"]!)
            cell.labelItemTitle.text = items[indexPath.row]["title"]
            cell.labelItemInfo.text = items[indexPath.row]["info"]
            return cell
            
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        case 1:
            return 64
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // favourite users
            let vc = R.storyboard.settings.listFriendsVC()
            navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 1 { // invite friends
            let vc = R.storyboard.settings.likedUsersVC()
            navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 2 {
            let vc = R.storyboard.settings.dislikeUsersVC()
            navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.row == 3 {
            let vc = R.storyboard.settings.favoriteVC()
            navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.row == 4{
            let vc = R.storyboard.blogs.blogsVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if indexPath.row == 5{
            let vc = R.storyboard.settings.inviteFriendsVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
