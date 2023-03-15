////
////  VoiceCallController.swift
////  QuickDate
////
////  Created by Ubaid Javaid on 12/23/20.
////  Copyright © 2020 Lê Việt Cường. All rights reserved.
////
//
//import UIKit
//import TwilioVideo
//import Async
//import AVFoundation
//import PushKit
//import CallKit
//import TwilioVoice
//
//class VoiceCallController:BaseVC,CallDelegate{
//
//
//    @IBOutlet var imageView: RoundImage!
//    @IBOutlet var callerName: UILabel!
//    @IBOutlet var timerLabel: UILabel!
//    @IBOutlet var micBtn: RoundButton!
//    @IBOutlet var speakerBtn: RoundButton!
//
//
//    // Configure access token manually for testing, if desired! Create one manually in the console
//    // at https://www.twilio.com/console/video/runtime/testing-tools
//    var accessToken = ""
//    var accessToken1 = ""
//
//    // Configure remote URL to fetch token from
//    let tokenUrl = "http://119.160.119.161:80/accessToken.php"
////    http://localhost/Twilio%20SDK/
//    // Automatically record audio for all `AudioTrack`s published in a Room.
//    let recordAudio = true
//
//    // Video SDK components
//    var room: TVIRoom?
////    var room: TVICall?
//    var camera: TVICameraSource?
//    var localAudioTrack: TVILocalAudioTrack!
//    var localVideoTrack: TVILocalVideoTrack!
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//
//    let kPreviewPadding = CGFloat(10)
//    let kTextBottomPadding = CGFloat(4)
//    let kMaxRemoteVideos = Int(2)
//    var roomId:String? = ""
//    var callID:Int? = 0
//    var speaker = "0"
//    var mic  = "0"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        TwilioVoice.audioDevice = audioDevice
//
////        prepareLocalMedia()
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
////                logMessage(messageText: message)
//                return
//            }
//        }
//
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//
//
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
//            builder.params = ["to": self.roomId ?? ""]
////            builder.uuid = uuid
//
//        }
//
//        let call = TwilioVoice.connect(options: connectOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//
//    }
//
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return self.room != nil
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return self.room != nil
//    }
//
//
//    @IBAction func Speaker(_ sender: Any) {
//        if (self.speaker == "0"){
//            self.speaker = "1"
//            self.speakerBtn.setImage(UIImage(named: "volume"), for: .normal)
//            self.setAudioOutputSpeaker(enabled: false)
//
//        }
//        else{
//            self.speaker = "1"
//            self.speakerBtn.setImage(UIImage(named: "mute"), for: .normal)
//            self.setAudioOutputSpeaker(enabled: true)
//        }
//
//    }
//
//    func setAudioOutputSpeaker(enabled: Bool)
//    {
//        let session = AVAudioSession.sharedInstance()
//        var _: Error?
//        try? session.setCategory(AVAudioSession.Category.playAndRecord)
//        try? session.setMode(AVAudioSession.Mode.voiceChat)
//        if enabled {
//            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//
//        }
//        else {
//            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//        }
//        try? session.setActive(true)
//    }
//
//
//    @IBAction func MicBtn(_ sender: Any) {
//       if self.mic == "0"{
//        self.mic = "1"
//        self.micBtn.setImage(UIImage(named: "microphone-off"), for: .normal)
//        guard let activeCall = activeCall else { return }
//        activeCall.isMuted = true
//        }
//       else{
//        self.mic = "0"
//        self.micBtn.setImage(UIImage(named: "voice"), for: .normal)
//        guard let activeCall = activeCall else { return }
//        activeCall.isMuted = false
//       }
//    }
//
//
//    @IBAction func DisconnectCall(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//     func prepareLocalMedia() {
//
//         // We will share local audio and video when we connect to the Room.
//
//         // Create an audio track.
//         if (localAudioTrack == nil) {
//             localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
//
//             if (localAudioTrack == nil) {
////                 logMessage(messageText: "Failed to create audio track")
//             }
//         }
//     }
//
//
//    private func deleteCall(callID:Int){
//        //        self.dismiss(animated: true, completion: nil)
//        let accessToken = AppInstance.instance.accessToken ?? ""
//
//        Async.background({
//            AudioCallManager.instance.deleteAudioCall(AccessToken: accessToken, callID: callID, completionBlock: { (success, sessionError, error) in
//                if success != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            log.debug("userList = \(success?.status ?? nil)")
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    })
//                }else if sessionError != nil{
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(sessionError?.errors?.errorText)
//                            log.error("sessionError = \(sessionError?.errors?.errorText)")
//
//                        }
//                    })
//                }else {
//                    Async.main({
//                        self.dismissProgressDialog {
//                            self.view.makeToast(error?.localizedDescription)
//                            log.error("error = \(error?.localizedDescription)")
//                        }
//                    })
//                }
//            })
//
//        })
//    }
//
//    func callDidConnect(call: Call) {
//        NSLog("callDidConnect:")
//    }
//
//    func callDidFailToConnect(call: Call, error: Error) {
//        NSLog("Call failed to connect: \(error.localizedDescription)")
//        callDisconnected(call: call)
//    }
//
//    func callDidDisconnect(call: Call, error: Error?) {
//        if let error = error {
//            NSLog("Call failed: \(error.localizedDescription)")
//        } else {
//            NSLog("Call disconnected")
//        }
//        callDisconnected(call: call)
//
//    }
//
//
//    private func callDisconnected(call: Call) {
//        if call == activeCall {
//            activeCall = nil
//        }
//
//        activeCalls.removeValue(forKey: call.uuid!.uuidString)
//    }
//
//}
//
