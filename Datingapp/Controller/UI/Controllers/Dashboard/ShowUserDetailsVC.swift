//
//  ShowUserDetailsVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/21/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import QuickdateSDK

class ShowUserDetailsVC: BaseVC {
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var object:ShowUserProfileModel? = nil
    var mediaFiles = [String]()
    var userMedia = [String]()
    var userData = [String:Any]()
    var users:[HotOrNotModel.Datum] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        //        self.mediaFiles.removeAll()
        chatBtn.circleView()
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.showUserDetailsTableitem(), forCellReuseIdentifier: R.reuseIdentifier.showUserDetailsTableitem.identifier)
        tableView.register(UINib(nibName: "UserImagesCell", bundle: nil), forCellReuseIdentifier: "UserImageCell")
        tableView.register(UINib(nibName: "UserAboutCell", bundle: nil), forCellReuseIdentifier: "UserAboutCell")
        tableView.register(UINib(nibName: "UserIntroCell", bundle: nil), forCellReuseIdentifier: "UserIntroCell")
        tableView.register(UINib(nibName: "UserHairCell", bundle: nil), forCellReuseIdentifier: "UserHeight&HairCell")
        tableView.register(UINib(nibName: "UserActivityCell", bundle: nil), forCellReuseIdentifier: "UserActivityCell")
        tableView.register(UINib(nibName: "UserLocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tableView.register(UINib(nibName: "UserSocialLinkCell", bundle: nil), forCellReuseIdentifier: "SocialLinkCell")
        
        self.mediaFiles.append(self.object?.avater ?? "")
        log.verbose("self.mediaFiles = \(self.mediaFiles)")
        self.getProfile()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func getProfile(){
        GetProfileManager.sharedInstance.getProfileData(user_id: object?.id ?? 0) { (success, authError, error) in
            if (success != nil){
                self.userData = success!.data
                if let media = self.userData["mediafiles"] as? [[String:Any]]{
                    for i in media{
                        self.userMedia.append(i["avater"] as? String ?? "")
                    }
                }
                if let isFriend = self.userData["is_friend"] as? Bool{
                    self.object?.isFriend = isFriend
                }
                if let isFriend_request = self.userData["is_friend_request"] as? Bool{
                    self.object?.is_friend_request = isFriend_request
                }
                if let isFav = self.userData["is_favorite"] as? Bool{
                    self.object?.isFavourite = isFav
                }
                self.tableView.reloadData()
            }
            else if (authError != nil){
                self.view.makeToast(authError?.message)
            }
            else if (error != nil){
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func chatPressed(_ sender: Any) {
        let vc = R.storyboard.chat.chatScreenVC()
        vc?.toUserId  = String(object?.id ?? 0)
        vc?.usernameString = object?.username ?? ""
        vc?.lastSeenString =  String(object?.lastseen ?? 0)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func likePressed(_ sender: Any) {
        self.addLike(UserId: self.object?.id ?? 0 )
    }
    @IBAction func dislikePressed(_ sender: Any) {
        self.dislIke(UserId: self.object?.id ?? 0 )
    }
    private func addLike(UserId:Int){
        self.navigationController?.popViewController(animated: true)
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = UserId
            Async.background({
                LikesManager.instance.likesAdd(AccessToken: accessToken, To_userId: UserId, likeiD: UserId, disLikeiD: nil, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    private func dislIke(UserId:Int){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = UserId
            Async.background({
                LikesManager.instance.likesAdd(AccessToken: accessToken, To_userId: UserId, likeiD: nil, disLikeiD: UserId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                log.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
    
}
extension ShowUserDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 1
        case 6:
            return 1
        case 7:
            return 1
        case 8:
            return 1
        case 9:
            return 1
        case 10:
            return 1
        default:
            return 1
        }
//        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showUserDetailsTableitem.identifier) as? ShowUserDetailsTableitem
            cell?.bind(self.object!, MediaFiles: self.mediaFiles)
            cell?.vc = self
            cell?.baseVC = self
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserAboutCell") as!
                UserAboutCell
            cell.selectionStyle = .none
            if let about = self.userData["about"] as? String{
                cell.aboutLabel.text = about.htmlAttributedString
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageCell") as!
                UserImagesCell
            cell.vc = self
            cell.selectionStyle = .none
            cell.mediaFiles = self.userMedia
            cell.collectionView.reloadData()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserHeight&HairCell") as! UserHairCell
            var heights = ""
            var hairs = ""
            if let height = self.userData["height_txt"] as? String{
                heights = height
            }
            if let hair = self.userData["hair_color_txt"] as? String{
               hairs = hair
            }
            cell.selectionStyle = .none
            cell.heightLabel.text = "\(heights) tall, \("I have")\(" ")\(hairs)\(" ")\("hair.")"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserIntroCell") as!
                UserIntroCell
            cell.selectionStyle = .none
            cell.bind(data: self.userData)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as!
                UserLocationCell
            if let loca = self.userData["location"] as? String{
                if (loca == ""){
                    cell.addressLabel.text = "Unknown"
                    cell.viewHeight.constant = 0.0
                }
                else{
                    cell.addressLabel.text = loca
                    cell.forwardGeoCode (address : loca)
                    cell.viewHeight.constant = 165.0
                }
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityCell") as!
                UserActivityCell
            if let work = self.userData["work_status_txt"] as? String{
                cell.headingCell.text = "Work and Education"
                cell.textsLabel.text = work.htmlAttributedString
            }
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityCell") as!
                UserActivityCell
            if let intrest = self.userData["interest"] as? String{
                cell.headingCell.text = "Interests"
                cell.textsLabel.text = intrest.htmlAttributedString
            }
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityCell") as!
                UserActivityCell
            if let language = self.userData["language"] as? String{
                cell.headingCell.text = "Language"
                cell.textsLabel.text = language.htmlAttributedString
            }
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialLinkCell") as!
                UserSocialLinkCell
            cell.bind(data: self.userData)
            cell.selectionStyle = .none
            return cell
        case 10:
            let cell = UITableViewCell()
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 330.0
        case 1:
            var about = ""
            if let abou = self.userData["about"] as? String{
                about = abou
            }
            if (about == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
        case 2:
            if (self.userMedia.isEmpty == true){
                return 0.0
            }
            else{
                return 125.0
            }
        case 3:
            var hairs = ""
            var heights = ""
           
            if let hair = self.userData["hair_color_txt"] as? String{
                hairs = hair
            }
            if let height = self.userData["height_txt"] as? String{
                heights = height
            }
            if (hairs == "") && (heights == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
        case 4:
            var relationShip = ""
            if let relation = self.userData["relationship_txt"] as? String{
                relationShip = relation
            }
            if (relationShip == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
        case 5:
          var loca = ""
            if let loc = self.userData["location"] as? String{
                loca = loc
            }
            if (loca == ""){
                return 55.0
            }
            else{
                return 165.0
            }
//            return UITableView.automaticDimension
        case 6:
            var work = ""
            if let works = self.userData["work_status_txt"] as? String{
                work = works
            }
            if (work == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
            
        case 7:
            var intrests = ""
            if let intrest = self.userData["interest"] as? String{
                intrests = intrest
            }
            if (intrests == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
        case 8:
            var languages = ""
            if let language = self.userData["language"] as? String{
                languages = language
            }
            if (languages == ""){
                return 0.0
            }
            else{
                return UITableView.automaticDimension
            }
        case 9:
            var google = ""
            var facebook = ""
            var insta = ""
            var web = ""
            if let facebok = self.userData["facebook"] as? String{
                facebook = facebok
            }
            if let googles = self.userData["google"] as? String{
                google = googles
            }
            if let instagram = self.userData["instagram"] as? String{
                insta = instagram
            }
            if let webs = self.userData["website"] as? String{
                web = webs
            }
            if (google != "") || (facebook != "") || (insta != "") || (web != ""){
                return 95.0
            }
            else{
                return 0.0
            }
        case 10:
            return 100.0
            
        default:
            return 100.0
        }
//        return 710.0
    }
}
