//
//  TrendingVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/3/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import FittedSheets
import QuickdateSDK

class TrendingVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filtrBtn: UIButton!
    
    var trendingUsers: [TrendingModel.Datum] = []
    var searchUsers: [SearchModel.Datum] = []
    var hotOrNotUsers: [HotOrNotModel.Datum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    private func setupUI(){
        self.filtrBtn.tintColor = UIColor.Button_StartColor
        
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.trendingUserTableItem(), forCellReuseIdentifier: R.reuseIdentifier.trendingUserTableItem.identifier)
        tableView.register( R.nib.hotOrNotTableItem(), forCellReuseIdentifier: R.reuseIdentifier.hotOrNotTableItem.identifier)
        tableView.register( R.nib.onlineUserTableItem(), forCellReuseIdentifier: R.reuseIdentifier.onlineUserTableItem.identifier)
        tableView.register( R.nib.headerTableItem(), forCellReuseIdentifier: R.reuseIdentifier.headerTableItem.identifier)
        tableView.register( R.nib.noTrendingDataTableItem(), forCellReuseIdentifier: R.reuseIdentifier.noTrendingDataTableItem.identifier)
       
        
    }
    @IBAction func filterPressed(_ sender: Any) {
        let vc = R.storyboard.trending.filterParentVC()
        let controller = SheetViewController(controller:vc!, sizes: [.fullScreen])
        controller.blurBottomSafeArea = true
        vc?.filterDelegate = self
        
        self.present(controller, animated: false, completion: nil)
    }
    
    //MARK: - Methods
    
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            self.trendingUsers.removeAll()
            trendingUsers.removeAll()
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            
            Async.background({
                TrendingManager.instance.getTrending(AccessToken: accessToken, Limit: 20, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("userList = \(success?.data ?? [])")
                            self.trendingUsers = success?.data ?? []
                            self.getHotOrNot()
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
    private func search(){
        if Connectivity.isConnectedToNetwork(){
            searchUsers.removeAll()
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                SearchManager.instance.Search(AccessToken: accessToken, Limit: 20, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? [])")
                                self.searchUsers = success?.data ?? []
                                self.tableView.reloadData()
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
    private func getHotOrNot(){
        if Connectivity.isConnectedToNetwork(){
            hotOrNotUsers.removeAll()
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                HotOrNotManager.instance.getHotOrNot(AccessToken: accessToken, limit: 20, offset: 0, genders: "") { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("userList = \(success?.data ?? [])")
                            self.hotOrNotUsers = success?.data ?? []
                            self.search()
                            
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
                }
                
            })
            
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
extension TrendingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0 :
            return 50
        case 1 :
//            return 120
            return 100.0
        case 2 :
            return 50
        case 3 :
            return 250
        case 4 :
            if self.searchUsers.count > 0{
                let height:Float = Float(self.searchUsers.count / 2)
                let totalHeight = height.rounded(.toNearestOrAwayFromZero)
                let width = view.frame.size.width / 2 - 12
                let heightOFCell = width + 80
                return (CGFloat(totalHeight) * heightOFCell ) + 80
            }else{
                return 300
            }
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.headerTableItem.identifier ) as? HeaderTableItem
            cell?.titleLabel.text = self.searchUsers.count != 0 ? NSLocalizedString("Pro Users", comment: "Pro Users") : ""
            cell?.viewMoreBtn.isHidden = true
            cell?.selectionStyle = .none
            return cell!
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.onlineUserTableItem.identifier ) as? OnlineUserTableItem
            cell?.bind(object: self.trendingUsers)
            cell?.vc = self
            cell?.selectionStyle = .none
            
            return cell!
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.headerTableItem.identifier ) as? HeaderTableItem
            cell?.titleLabel.text = self.searchUsers.count != 0 ? NSLocalizedString("Hot or Not", comment: "Hot or Not") : ""
            cell?.viewMoreBtn.setTitle(self.searchUsers.count != 0 ? NSLocalizedString("View More", comment: "View More") : "", for: .normal)
            cell?.viewMoreBtn.isHidden = false
            cell?.selectionStyle = .none
            cell!.vc = self
            return cell!
        case 3 :
            let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.hotOrNotTableItem.identifier ) as? HotOrNotTableItem
            cell?.bind(object: self.hotOrNotUsers)
            cell?.vc = self
            cell?.selectionStyle = .none
            return cell!
        case 4 :
            
            if self.searchUsers.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.trendingUserTableItem.identifier ) as? TrendingUserTableItem
                cell?.bind(object: self.searchUsers)
                cell?.vc = self
                return cell!
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.noTrendingDataTableItem.identifier ) as? NoTrendingDataTableItem
                return cell!
            }
            
        default:
            return UITableViewCell()
        }
    }
    
}
extension TrendingVC:FilterDelegate{
    func filter(status: Bool, searchArray:[SearchModel.Datum]) {
        self.searchUsers.removeAll()
        self.tableView.reloadData()
        self.searchUsers = searchArray
        //        if searchArray.isEmpty{
        //            self.noDataImage.isHidden = false
        //            self.noDataLabel.isHidden = false
        //        }else {
        //            self.noDataImage.isHidden = true
        //            self.noDataLabel.isHidden = true
        //            self.trendingCollectionView.reloadData()
        //        }
        self.tableView.reloadData()
    }
    
    
}
