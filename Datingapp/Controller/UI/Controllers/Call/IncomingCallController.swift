//
//  IncomingCallController.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/20/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
import Toast_Swift
import JGProgressHUD
import SwiftEventBus
import Async
import SDWebImage
import QuickdateSDK
import OneSignal
import Toast
import AVFoundation
import AVKit

class IncomingCallController: UIViewController {
    
    
    @IBOutlet var imageView: RoundImage!
    @IBOutlet var callStatus: UILabel!
    @IBOutlet var callerName: UILabel!
    
    var vc:BaseVC?
    var hud : JGProgressHUD?
    
    var callername = ""
    var callStatuss = ""
    var call_id = 0
    var imageURL = ""
    var isVoice = false
    private var timer = Timer()
    private var callAudioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callerName.text = callername
        self.callStatus.text = callStatuss
        let url = URL(string: self.imageURL)
        self.imageView.sd_setImage(with: url, completed: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playCallSoundSound()
        self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
    
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = NSLocalizedString(text, comment: text)
        hud?.show(in: self.view)
    }
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
        hud?.dismiss()
        completionBlock()
        
    }
    
    private func answerCall(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.instance.accessToken ?? ""
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.answerAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("Call Has been Answered )")
                                let vc = R.storyboard.call.tempVCalling()
                                vc?.accessToken = success?.data.accessToken2 ?? ""
                                print(vc?.accessToken)
                                vc?.roomId = success?.data.roomName ?? ""
                                self.dismiss(animated: true) {
                                    vc?.modalPresentationStyle = .fullScreen
                                    self.present(vc!, animated: true, completion: nil)
                                }

                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
                
            })
        }else{
            Async.background({
                VideoCallManager.instance.answerVideoCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("Video call has been answered")
                                let vc = R.storyboard.call.tempVCalling()
                                vc?.accessToken = success?.data.accessToken2 ?? ""
                                vc?.roomId = success?.data.roomName ?? ""
                                self.dismiss(animated: true) {
                                    vc?.modalPresentationStyle = .fullScreen
                                    self.vc?.present(vc!, animated: true, completion: nil)
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
             
            })
        }
    }

    
    private func declineCall(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.instance.accessToken ?? ""
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.declineAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.dismiss(animated: true, completion: nil)
                                log.debug("userList = \(success?.status ?? nil)")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
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
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
    }
    
    
    private func checkForCallAction(callID:Int,callTypeBool:Bool){
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        if callTypeBool{
            Async.background({
                AudioCallManager.instance.checkForAudioCallAnswer(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
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
                                        self.timer.invalidate()
                                        
                                    })
                                    
            
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.status == 400{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    log.verbose("No Answer")
                                }
                                
//                                if success?.status == 300{
//                                    log.verbose("Call Has Been Declined")
//                                    self.view.makeToast("Call Has Been Declined")
//                                }else if success?.status ==  200{
//                                    self.view.makeToast("Call Has Been Answered")
//                                    log.verbose("Call Has Been Answered")
//                                    self.timer.invalidate()
//
//                                }else if  success?.status == 400{
////                                    self.alert.dismiss(animated: true, completion: nil)
//                                    self.view.makeToast("No Answer")
//                                    log.verbose("No Answer")
//                                    self.timer.invalidate()
//
//                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
            
        }else{
            Async.background({
                VideoCallManager.instance.checkForVideoCallAnswer(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                
                                if success?.status == 300{
                                    log.verbose("Call Has Been Declined")
                                }else if success?.status ==  200{
                                    log.verbose("Call Has Been Answered")
                                    self.timer.invalidate()

                                }else if  success?.status == 400{
//                                    self.alert!.dismiss(animated: true, completion: nil)
                                    log.verbose("No Answer")
                                    self.timer.invalidate()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
        
    }
    
    @objc func update() {
        self.checkForCallAction(callID:self.call_id ?? 0, callTypeBool: self.isVoice ?? false)
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
    
    @IBAction func CallReceivedBtn(_ sender: Any) {
        self.answerCall(callID: self.call_id, callTypeBool: self.isVoice)
    }
    
    @IBAction func CallDeclineBtn(_ sender: Any) {
        self.timer.invalidate()
        self.declineCall(callID: self.call_id, callTypeBool: self.isVoice)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
