//
//  profileVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/17/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
class profileVC: BaseVC {
    
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    private func setupUI(){
        self.myProfileLabel.text = NSLocalizedString("My Profile", comment: "My Profile")
        
    }
}

extension profileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 320
        case 1:
            return 80
        case 2:
            return 80
        case 3:
            return 288
        case 4:
            return 80
        case 5:
            return 176
        case 6:
            return 187
        case 7:
            return 249
        case 8:
            return 368
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImagesCellID", for: indexPath) as! ProfileImagesCell
            cell.selectionStyle = .none
            cell.vc = self
            let object = AppInstance.instance.userProfile
            if (object?.data?.mediafiles!.isEmpty)!{
                cell.imageView1.image = R.image.thumbnail()
                cell.imageView2.image = R.image.thumbnail()
                cell.imageView3.image = R.image.thumbnail()
                cell.imageView4.image = R.image.thumbnail()
                cell.imageView5.image = R.image.thumbnail()
                cell.imageView6.image = R.image.thumbnail()
                
            }else{
                if object?.data?.mediafiles?.count == 1{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    
                    
                }else if object?.data?.mediafiles?.count == 2{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    
                    
                }else if object?.data?.mediafiles?.count == 3{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    let url3 = URL(string: object?.data?.mediafiles?[2].avater ?? "")
                    
                    
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    
                    
                    
                }else if object?.data?.mediafiles?.count == 4{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    let url3 = URL(string: object?.data?.mediafiles?[2].avater ?? "")
                    let url4 = URL(string: object?.data?.mediafiles?[3].avater ?? "")
                    
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    
                    
                }else if object?.data?.mediafiles?.count == 5{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    let url3 = URL(string: object?.data?.mediafiles?[2].avater ?? "")
                    let url4 = URL(string: object?.data?.mediafiles?[3].avater ?? "")
                    let url5 = URL(string: object?.data?.mediafiles?[4].avater ?? "")
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    
                    
                }else if object?.data?.mediafiles?.count == 6{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    let url3 = URL(string: object?.data?.mediafiles?[2].avater ?? "")
                    let url4 = URL(string: object?.data?.mediafiles?[3].avater ?? "")
                    let url5 = URL(string: object?.data?.mediafiles?[4].avater ?? "")
                    let url6 = URL(string: object?.data?.mediafiles?[5].avater ?? "")
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    cell.imageView6.sd_setImage(with: url6, placeholderImage: R.image.thumbnail())
                    
                }else{
                    let url1 = URL(string: object?.data?.mediafiles?[0].avater ?? "")
                    let url2 = URL(string: object?.data?.mediafiles?[1].avater ?? "")
                    let url3 = URL(string: object?.data?.mediafiles?[2].avater ?? "")
                    let url4 = URL(string: object?.data?.mediafiles?[3].avater ?? "")
                    let url5 = URL(string: object?.data?.mediafiles?[4].avater ?? "")
                    let url6 = URL(string: object?.data?.mediafiles?[5].avater ?? "")
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    cell.imageView6.sd_setImage(with: url6, placeholderImage: R.image.thumbnail())
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCompletedPercentsCellID", for: indexPath) as! ProfileCompletedPercentsCell
            cell.selectionStyle = .none

            let value = Double(((AppInstance.instance.userProfile?.data?.profileCompletion)!))
            cell.percentProgressView.progress = Float(((AppInstance.instance.userProfile?.data?.profileCompletion!)!))/100.0
            cell.percentLabel.text = "\(AppInstance.instance.userProfile?.data?.profileCompletion ?? 0)%"
            
            cell.percentProgressView.progressTintColor = .Main_StartColor
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCellID", for: indexPath) as! AboutMeCell
            cell.selectionStyle = .none
            cell.vc = self
            
            let userData = AppInstance.instance.userProfile?.data
            if userData?.about == ""{
                cell.aboutMeLabel.text = "------"
                
            }else{
                cell.aboutMeLabel.text = userData?.about ?? ""
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCellID", for: indexPath) as! ProfileInfoCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            if userData?.fullName == ""{
                cell.nameLabel.text = "-----"
            }else{
                cell.nameLabel.text = userData?.fullName ?? "Empty"
            }
            if userData?.gender == ""{
                cell.genderLabel.text = "-----"
            }else{
                cell.genderLabel.text = userData?.gender ?? "Empty"
            }
            if userData?.birthday == ""{
                cell.birthdayLabel.text = "-----"
            }else{
                
                cell.birthdayLabel.text  = userData?.birthday ?? "Empty"
            }
            if userData?.location == ""{
                cell.locationLabel.text = "-----"
            }else{
                
                cell.locationLabel.text = userData?.location ?? "Empty"
            }
            if userData?.languageTxt == ""{
                cell.languageLabel.text = "-----"
            }else{
                
                cell.languageLabel.text = userData?.languageTxt ?? "Empty"
            }
            if userData?.relationshipTxt == ""{
                cell.relationshipStatus.text = "-----"
            }else{
                
                cell.relationshipStatus.text = userData?.relationshipTxt ?? "Empty"
            }
            if userData?.workStatusTxt == ""{
                cell.workStatus.text = "-----"
            }else{
                
                
                cell.workStatus.text = userData?.workStatusTxt ?? "Empty"
            }
            if userData?.educationTxt == ""{
                cell.educationLabel.text = "-----"
                
            }else{
                cell.educationLabel.text = userData?.educationTxt ?? "Empty"
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterestsCellID", for: indexPath) as! InterestsCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            if userData?.interest == ""{
                cell.interestsLabel.text = "------"
                
            }else{
                cell.interestsLabel.text = userData?.interest ?? ""
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LooksCellID", for: indexPath) as! LooksCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            
            if userData?.ethnicityTxt == ""{
                cell.ethenicityLabel.text = "-----"
            }else{
                cell.ethenicityLabel.text = userData?.ethnicityTxt ?? "Empty"
            }
            if userData?.bodyTxt == ""{
                cell.bodyTypeLabel.text = "-----"
            }else{
                cell.bodyTypeLabel.text = userData?.bodyTxt ?? "Empty"
            }
            if userData?.heightTxt == ""{
                cell.heightLabel.text = "-----"
            }else{
                cell.heightLabel.text = userData?.heightTxt ?? "Empty"
            }
            if userData?.hairColorTxt == ""{
                cell.hairCOlor.text = "-----"
                
            }else{
                
                cell.hairCOlor.text = userData?.hairColorTxt ?? "Empty"
            }
            
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalityCellID", for: indexPath) as! PersonalityCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            if userData?.characterTxt == ""{
                cell.characterLabel.text = "-----"
            }else{
                cell.characterLabel.text = userData?.characterTxt ?? "Empty"
            }
            if userData?.childrenTxt == ""{
                cell.chidrenLabel.text = "-----"
            }else{
                
                cell.chidrenLabel.text = userData?.childrenTxt ?? "Empty"
            }
            if userData?.friendsTxt == ""{
                cell.friendsLabel.text = "-----"
            }else{
                cell.friendsLabel.text = userData?.friendsTxt ?? "Empty"
            }
            if userData?.pets == ""{
                cell.petLabel.text = "-----"
                
            }else{
                cell.petLabel.text = userData?.pets ?? "Empty"
                
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LifeStyleCellID", for: indexPath) as! LifeStyleCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            if userData?.liveWithTxt == ""{
                
                cell.iLiveWithLabel.text = "-----"
            }else{
                cell.iLiveWithLabel.text = userData?.liveWithTxt ?? "Empty"
            }
            if userData?.carTxt == ""{
                cell.carLabel.text = "-----"
            }else{
                cell.carLabel.text = userData?.carTxt ?? "Empty"
            }
            if userData?.religionTxt == ""{
                cell.religionLabel.text = "-----"
            }else{
                cell.religionLabel.text = userData?.religionTxt ?? "Empty"
            }
            if userData?.smokeTxt == ""{
                cell.smokeLabel.text = "-----"
                
            }else{
                
                cell.smokeLabel.text = userData?.smokeTxt ?? "Empty"
            }
            if userData?.drinkTxt == ""{
                cell.drinkLabel.text = "-----"
                
            }else{
                cell.drinkLabel.text = userData?.drinkTxt ?? "Empty"
            }
            if userData?.travelTxt == ""{
                cell.travelLabel.text = "-----"
                
            }else{
                cell.travelLabel.text = userData?.travelTxt ?? "Empty"
            }
            return cell
            
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCellID", for: indexPath) as! FavouritesCell
            cell.selectionStyle = .none
            cell.vc = self
            let userData = AppInstance.instance.userProfile?.data
            if userData?.music == ""{
                
                cell.musicGenreLabel.text = "-----"
            }else{
                cell.musicGenreLabel.text = userData?.music ?? "Empty"
            }
            if userData?.dish == ""{
                cell.dishLabel.text = "-----"
            }else{
                cell.dishLabel.text = userData?.dish ?? "Empty"
            }
            if userData?.song == ""{
                cell.songLabel.text = "-----"
            }else{
                cell.songLabel.text = userData?.song ?? "Empty"
            }
            if userData?.hobby == ""{
                cell.hobbyLabel.text = "-----"
            }else{
                cell.hobbyLabel.text = userData?.hobby ?? "Empty"
            }
            if userData?.city == ""{
                cell.cityLabel.text = "-----"
            }else{
                cell.cityLabel.text = userData?.city ?? "Empty"
            }
            if userData?.sport == ""{
                cell.sportLabel.text = "-----"
            }else{
                cell.sportLabel.text = userData?.sport ?? "Empty"
            }
            if userData?.book == ""{
                cell.bookLabel.text = "-----"
            }else{
                cell.bookLabel.text = userData?.book ?? "Empty"
            }
            if userData?.movie == ""{
                cell.movieLabel.text = "-----"
            }else{
                cell.movieLabel.text = userData?.movie ?? "Empty"
            }
            if userData?.colour == ""{
                cell.colorLabel.text = "-----"
            }else{
                cell.colorLabel.text = userData?.colour ?? "Empty"
            }
            if userData?.tv == ""{
                cell.tvShowLabel.text = "-----"
            }else{
                cell.tvShowLabel.text = userData?.tv ?? "Empty"
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImagesCellID", for: indexPath) as! ProfileImagesCell
            cell.selectionStyle = .none
            return cell
        }
    }
}
