//
//  ChatScreenVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/4/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async
import DropDown
import FittedSheets
import QuickdateSDK
import IQKeyboardManagerSwift
import SwiftEventBus

class ChatScreenVC: BaseVC {
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var lastSeenLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var inputMessageView: UIView!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var giftButton: UIButton!
    @IBOutlet var stickerButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var chatList: [GetChatConversationModel.Datum] = []
    var toUserId:String? = ""
    var usernameString:String? = ""
    var lastSeenString:String? = ""
    var lastSeen:String? = ""
    var profileImageString:String? = ""
    private var messageCount:Int? = 0
    private var scrollStatus:Bool? = true
    private let moreDropdown = DropDown()
    private let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.customizeDropdown()
        self.fetchData()
        log.verbose("To USerId = \(self.toUserId ?? "")")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
//        let userInfo = (notification as NSNotification).userInfo!
//        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//        bottomConstraints?.constant = keyboardFrame!.height
//        animatedKeyBoard(scrollToBottom: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
//        bottomConstraints?.constant = 0
//        animatedKeyBoard(scrollToBottom: false)
    }
    
    fileprivate func animatedKeyBoard(scrollToBottom: Bool) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            if scrollToBottom {
                self.view.layoutIfNeeded()
            }
        }, completion: { (completed) in
            if scrollToBottom {
                if !self.chatList.isEmpty {
                    let indexPath = IndexPath(item: self.chatList.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        })
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        hideNavigation(hide: true)
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
            
        }
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
        }
//        if ControlSettings.isAudio{
//            self.audioBtn.isHidden = false
//        }else{
//            self.audioBtn.isHidden = true
//        }
//        if ControlSettings.isVideo{
//            self.videoBtn.isHidden = false
//        }else{
//            self.videoBtn.isHidden = true
//        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        hideNavigation(hide: false)
        
    }
    
    @IBAction func callPressed(_ sender: Any) {
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "voiceCall"
        vc?.delegate = self
        vc?.profileImageString = self.profileImageString ?? ""
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func videoPressed(_ sender: Any) {
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "videoCall"
        vc?.profileImageString = self.profileImageString ?? ""
        vc?.delegate = self
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    //MARK: - Methods
    
    private func setupUI(){
        self.sendBtn.backgroundColor = .Button_StartColor
        self.messageTextfield.placeholder = NSLocalizedString("Write your message", comment: "Write your message")
        self.receiverNameLabel.text = self.usernameString ?? ""
        self.lastSeenLabel.text = setTimestamp(epochTime: self.lastSeenString ?? "")
        tableView.delegate = self
        tableView.dataSource = self
        self.sendBtn.circleView()
        self.tableView.register( R.nib.chatStickerSenderCell(), forCellReuseIdentifier: R.reuseIdentifier.chatStickerSenderCell.identifier)
        self.tableView.register( R.nib.chatStickerReceiverCell(), forCellReuseIdentifier: R.reuseIdentifier.chatStickerReceiverCell.identifier)
        
        self.tableView.register( R.nib.chatSenderTableItem(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier)
        self.tableView.register( R.nib.chatReceiverTableItem(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier)
        self.tableView.register( R.nib.senderImageTableItem(), forCellReuseIdentifier: R.reuseIdentifier.senderImageTableItem.identifier)
        self.tableView.register( R.nib.receiverImageTableItem(), forCellReuseIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier)
        
        let proUser = AppInstance.instance.userProfile?.data?.isPro
        if proUser == "0"{
            self.videoBtn.isHidden = true
            self.audioBtn.isHidden = true
        }
    }
    func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Block", comment: "Block"),NSLocalizedString("Clear chat", comment: "Clear chat")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.menuButton
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.blockUser()
                
            }else if index == 1{
                self.clearChat()
            }
            
            print("Index = \(index)")
        }
        
    }
    
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            chatList.removeAll()
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                ChatManager.instance.getChatConversation(AccessToken: accessToken, To_userId: toID, Limit: 100, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.chatList = success?.data ?? []
                                self.tableView.reloadData()
                                if self.scrollStatus!{
                                    
                                    if self.chatList.count == 0{
                                        log.verbose("Will not scroll more")
                                    }else{
                                        self.scrollStatus = false
                                        self.messageCount = self.chatList.count ?? 0
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                        
                                    }
                                }else{
                                    if self.chatList.count > self.messageCount!{
                                        
                                        self.messageCount = self.chatList.count ?? 0
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                    }else{
                                        log.verbose("Will not scroll more")
                                    }
                                    log.verbose("Will not scroll more")
                                }
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
    
    
    private func sendSticker() {
        
    }
    
    private func sendMedia() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title:NSLocalizedString("Gallery", comment: "Gallery") , style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    private func sendMessage(){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTextfield.text ?? ""
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendMessage(AccessToken: accessToken, To_userId: toID, Message: messageText, Hash_Id: messageHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            log.debug("userList = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                            
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
    }
    
    private func clearChat(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                ChatManager.instance.clearChat(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
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
    private func blockUser(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(text: "Loading...")
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
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
    func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as!
            TimeInterval)
        
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)
        
        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }
                        
                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "h:mm a"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
    }
    
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.moreDropdown.show()
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        self.sendMessage()
        
        self.messageTextfield.text = ""
        
    }
    
    @IBAction func imageButtonAction(_ sender: Any) {
        self.sendMedia()
    }
    
    @IBAction func stickerButtonAction(_ sender: Any) {
        let vc = R.storyboard.chat.stickersViewController()
        let controller = SheetViewController(controller:vc!)
        controller.blurBottomSafeArea = true
        vc?.stickerDelegate = self
        vc?.checkStatus = false
        self.present(controller, animated: false, completion: nil)
        
    }
    
    @IBAction func giftButtonAction(_ sender: Any) {
        let vc = R.storyboard.chat.stickersViewController()
        let controller = SheetViewController(controller:vc!)
        controller.blurBottomSafeArea = true
        vc?.giftDelegate = self
        vc?.checkStatus = true
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func emoButtonAction(_ sender: Any) {
    }
}

extension ChatScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.chatList.isEmpty{
            return UITableView.automaticDimension
        }else{
            let object = self.chatList[indexPath.row] ?? nil
            switch object?.messageType {
            case "media":
                return 200
            case "sticker":
                return 200
            default:
                return UITableView.automaticDimension
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.chatList.count == 0{
            return UITableViewCell()
            
        }else{
            let object = chatList[indexPath.row]
            
            if object.messageType == "text"{
                if object.from == AppInstance.instance.userId {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier) as? ChatReceiverTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier) as? ChatSenderTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }else if object.messageType ==  "sticker"{
                if object.from == AppInstance.instance.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier) as? ReceiverImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.senderImageTableItem.identifier) as? SenderImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }else {
                if object.from == AppInstance.instance.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier) as? ReceiverImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.senderImageTableItem.identifier) as? SenderImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }
        }
    }
}
extension  ChatScreenVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let convertedImageData = image.jpegData(compressionQuality: 0.2)
        self.sendMedia(ImageData: convertedImageData!)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    private func sendMedia(ImageData:Data){
        let mediaHashId = Int(arc4random_uniform(UInt32(100000)))
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendMedia(AccessToken: accessToken, To_userId: toID, Hash_Id: mediaHashId, MediaData: ImageData, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
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
    }
}
extension ChatScreenVC:didSelectStickerDelegate{
    func selectSticker(stickerId: Int) {
        sendSticker(stickerID: stickerId)
    }
    private func sendSticker(stickerID:Int){
        let stickerHashId = Int(arc4random_uniform(UInt32(100000)))
        let stickerId = stickerID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendSticker(AccessToken: accessToken, To_userId: toID, StickerId: stickerId, Hash_Id: stickerHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
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
    }
    
}
extension ChatScreenVC:didSelectGiftDelegate{
    func selectGift(giftId: Int) {
        sendGift(giftID: giftId)
    }
    private func sendGift(giftID:Int){
        let giftHashId = Int(arc4random_uniform(UInt32(100000)))
        let giftId = giftID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendGift(AccessToken: accessToken, To_userId: toID, GiftId: giftID, Hash_Id: giftHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
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
    }
    
}

extension ChatScreenVC:ReceiveCallDelegate{
    func receiveCall(status: Bool, profileImage: String, CallId: Int, AccessToken: String, RoomId: String, username: String, isVoice: Bool) {
        if isVoice{
            let vc = R.storyboard.call.tempVCalling()
            vc?.accessToken = AccessToken
            vc?.roomId = RoomId
//            vc?.callID = CallId
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = R.storyboard.call.tempVCalling()
            vc?.accessToken = AccessToken
            vc?.roomId = RoomId
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
        
    }
    
    
}
