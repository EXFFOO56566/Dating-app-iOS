

import UIKit
import Async
import QuickdateSDK
import AVFoundation
import AVKit
import JGProgressHUD

class CallVC: UIViewController {
    
    @IBOutlet weak var callingTypeLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var speakerBtn: RoundButton!
    @IBOutlet var micBtn: RoundButton!
    
    var username:String? = ""
    var callingType:String? = ""
    var toUSerId:String? = ""
    var profileImageString:String? = ""
    private var callAudioPlayer: AVAudioPlayer?
    private var callId:Int? = 0
    private var roomID:String? = ""
    private var timer = Timer()
    var delegate: ReceiveCallDelegate?
    var hud : JGProgressHUD?
    var speaker = "0"
    var mic  = "0"
    private var accessTokenID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.playCallSoundSound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.CallUser()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.declineCall(callID: self.callId ?? 0)
        
    }
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
    }
    private func setupUI(){
        self.fullnameLabel.text = self.username ?? ""
        let url = URL(string: profileImageString ?? "")
        profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if self.callingType == "voiceCall"{
            self.callingTypeLabel.text = "Voice Call"
        }else{
            self.callingTypeLabel.text = "Video Call"
        }
        
    }
    func playCallSoundSound() {
        guard let url = Bundle.main.url(forResource: "mystic_call", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            callAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            callAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = callAudioPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func CallUser(){
        
        let toUserId = self.toUSerId?.toInt() ?? 0
        let sessionID = AppInstance.instance.accessToken ?? ""
        
        if self.callingType == "videoCall"{
            Async.background({
                VideoCallManager.instance.createVideoCall(AccessToken: sessionID, toUserId: toUserId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.user2 ?? nil)")
                                self.callId = success?.data?.id ?? 0
                                self.roomID = success?.data?.roomID ?? nil
                                log.verbose("self.callId = \(self.callId)")
                                self.accessTokenID = (success?.data?.accessToken)!
                                self.checkForCallAction(callID: self.callId!, callingStatus: self.callingType!, accessToken: self.accessTokenID)
                                self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Async.background({
                AudioCallManager.instance.createAudioCall(AccessToken: sessionID, toUserId: toUserId, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data?.id  ?? 0)")
                                self.callId = success?.data?.id ?? 0
                                //                                self.checkForCallAction(callID: self.callId!, callingStatus: self.callingStyle!, accessToken: "")
                                self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
    }
    
    @objc func update() {
        self.checkForCallAction(callID: self.callId!, callingStatus: callingType!, accessToken: self.accessTokenID)
    }
    
    private func checkForCallAction(callID:Int,callingStatus:String, accessToken:String){
        let sessionID = AppInstance.instance.accessToken ?? ""
        
        if callingType == "voiceCall"{
            Async.background({
                AudioCallManager.instance.checkForAudioCallAnswer(AccessToken: sessionID, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                
                                if success?.status == 300{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    log.verbose("Call Has Been Declined")
                                }else if success?.status ==  200{
                                    self.dismiss(animated: true, completion: {
                                        log.verbose("success Status = \(success?.data)")
                                        self.delegate?.receiveCall(status: true, profileImage: self.profileImageString ?? "", CallId: self.callId ?? 0 , AccessToken: success?.data?.accessToken ?? "", RoomId: success?.data?.roomName ?? "", username: self.username ?? "", isVoice: true)
                                        
                                        self.timer.invalidate()
                                    })
                                    
                                    
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.status == 400{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    log.verbose("No Answer")
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
            
        }else{
            Async.background({
                VideoCallManager.instance.checkForVideoCallAnswer(AccessToken: sessionID, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                
                                if success?.status == 300{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    log.verbose("Call Has Been Declined")
                                }else if success?.status ==  200{
                                    //for video call
                                    if self.callingType == "videoCall" {
                                        self.dismiss(animated: true, completion: {
                                            self.delegate?.receiveCall(status: true, profileImage: self.profileImageString ?? "", CallId: self.callId ?? 0 , AccessToken: accessToken, RoomId: success?.data?.roomName ?? "", username: self.username ?? "", isVoice: false)
                                            self.timer.invalidate()
                                        })
                                    }
                        
                                    //for audio call
                                    else {
                                        log.verbose("success Status = \(success?.data)")
                                        
                                        self.dismiss(animated: true, completion: {
                                            self.delegate?.receiveCall(status: true, profileImage: self.profileImageString ?? "", CallId: self.callId ?? 0 , AccessToken: accessToken, RoomId: success?.data?.roomName ?? "", username: self.username ?? "", isVoice: true)
                                            self.timer.invalidate()
                                            
                                        })
                                        
                                    
                                    }
                                    
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.status == 400{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    log.verbose("No Answer")
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
    }
    
    private func declineCall(callID:Int){
        //        self.dismiss(animated: true, completion: nil)
        let accessToken = AppInstance.instance.accessToken ?? ""
        if self.callingType != "voiceCall"{
            Async.background({
                AudioCallManager.instance.declineAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.status ?? nil)")
                                self.dismiss(animated: true, completion: {
                                    self.timer.invalidate()
                                })
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
                
            })
        }else{
            Async.background({
                VideoCallManager.instance.declineVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.status ?? nil)")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
    }
    
    func setAudioOutputSpeaker(enabled: Bool)
    {
        let session = AVAudioSession.sharedInstance()
        var _: Error?
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.setMode(AVAudioSession.Mode.voiceChat)
        if enabled {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        
        }
        else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
    }
    
    
    
    @IBAction func Mic(_ sender: Any) {
//        if self.mic == "0"{
         self.mic = "1"
         self.micBtn.setImage(UIImage(named: "microphone-off"), for: .normal)
//         guard let activeCall = activeCall else { return }
//         activeCall.isMuted = true
//         }
//        else{
         self.mic = "0"
         self.micBtn.setImage(UIImage(named: "voice"), for: .normal)
//         guard let activeCall = activeCall else { return }
//         activeCall.isMuted = false
//        }
    }
    
    
    @IBAction func Speaker(_ sender: Any) {
        if (self.speaker == "0"){
            self.speaker = "1"
            self.speakerBtn.setImage(UIImage(named: "volume"), for: .normal)
            self.setAudioOutputSpeaker(enabled: false)

        }
        else{
            self.speaker = "1"
            self.speakerBtn.setImage(UIImage(named: "mute"), for: .normal)
            self.setAudioOutputSpeaker(enabled: true)
        }
    }
    
    
}
