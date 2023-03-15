//
//import UIKit
//import TwilioVideo
//import TwilioVoice
//import UIKit
//import Async
//class VoiceCallVC: BaseVC,CallDelegate {
//
//    // MARK:- View Controller Members
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
//    var camera: TVICameraSource?
//    var localAudioTrack: TVILocalAudioTrack!
//    var localVideoTrack: TVILocalVideoTrack!
//
//    // Audio Sinks
//
//    // MARK:- UI Element Outlets and handles
//
//    @IBOutlet weak var connectButton: UIButton!
//    @IBOutlet weak var disconnectButton: UIButton!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var remoteViewStack: UIStackView!
//    @IBOutlet weak var roomTextField: UITextField!
//    @IBOutlet weak var roomLine: UIView!
//    @IBOutlet weak var roomLabel: UILabel!
//
//    // Speech UI
//    weak var dimmingView: UIView!
//    weak var speechLabel: UILabel!
//
//    var messageTimer: Timer!
//
//    let kPreviewPadding = CGFloat(10)
//    let kTextBottomPadding = CGFloat(4)
//    let kMaxRemoteVideos = Int(2)
//    var roomId:String? = ""
//    var callID:Int? = 0
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.connectButton.isHidden = true
//        self.roomTextField.isHidden = true
//        self.roomTextField.text = self.roomId ?? ""
////        title = "AudioSink Example"
//        disconnectButton.isHidden = true
//        disconnectButton.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .disabled)
//        connectButton.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .disabled)
//        roomTextField.autocapitalizationType = .none
//        roomTextField.delegate = self
//
//        if (recordAudio == false) {
//            navigationItem.leftBarButtonItem = nil
//        }
//
//        prepareLocalMedia()
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
//                logMessage(messageText: message)
//                return
//            }
//        }
//
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
//            builder.params = ["to": self.roomId ?? ""]
////            builder.uuid = uuid
//
//        }
//
//        let call = TwilioVoice.connect(options: connectOptions, delegate: self)
//        activeCall = call
////        activeCalls[call.uuid!.uuidString] = call
//
//
////        let connectOptions = TVIConnectOptions(token: accessToken) { (builder) in
////
////            if let audioTrack = self.localAudioTrack {
////                builder.audioTracks = [audioTrack]
////            }
////            if let videoTrack = self.localVideoTrack {
////                builder.videoTracks = [videoTrack]
////            }
////
////            // Use the preferred codecs
////            if let preferredAudioCodec = Settings.shared.audioCodec {
////                builder.preferredAudioCodecs = [preferredAudioCodec]
////            }
////            if let preferredVideoCodec = Settings.shared.videoCodec {
////                builder.preferredVideoCodecs = [preferredVideoCodec]
////            }
////
////            // Use the preferred encoding parameters
////            if let encodingParameters = Settings.shared.getEncodingParameters() {
////                builder.encodingParameters = encodingParameters
////            }
////
////            // Use the preferred signaling region
////
////
////            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
////            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
////            builder.roomName = self.roomId ?? ""
////        }
//
//        // Connect to the Room using the options we provided.
////        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//
////        logMessage(messageText: "Connecting to \(roomTextField.text ?? "a Room")")
//
////        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//
//    }
//
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
////        activeCalls.removeValue(forKey: call.uuid!.uuidString)
//    }
//
//
//
//
////    func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
////        let alertController = UIAlertController(title: "Voice Quick Start",
////                                                message: "Microphone permission not granted",
////                                                preferredStyle: .alert)
////
////        let continueWithoutMic = UIAlertAction(title: "Continue without microphone", style: .default) { [weak self] _ in
//////            self?.performStartCallAction(uuid: uuid, handle: handle)
////        }
////
////        let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
////            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
////                                      options: [UIApplicationOpenURLOptionUniversalLinksOnly: false],
////                                      completionHandler: nil)
////        }
////
////        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
//////            self?.toggleUIState(isEnabled: true, showCallControl: false)
//////            self?.stopSpin()
////        }
////
////        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
////
////        present(alertController, animated: true, completion: nil)
////    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    // MARK:- IBActions
//    @IBAction func connect(sender: AnyObject) {
//        // Configure access token either from server or manually.
//        // If the default wasn't changed, try fetching from server.
//        if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
//                logMessage(messageText: message)
//                return
//            }
//        }
//
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        let connectOptions = TVIConnectOptions(token: accessToken) { (builder) in
//
//            if let audioTrack = self.localAudioTrack {
//                builder.audioTracks = [audioTrack]
//            }
//            if let videoTrack = self.localVideoTrack {
//                builder.videoTracks = [videoTrack]
//            }
//
//            // Use the preferred codecs
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
//
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//
//            // Use the preferred signaling region
//
//
//            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
//            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
//            builder.roomName = self.roomId ?? ""
//        }
//
//        // Connect to the Room using the options we provided.
//        room = TwilioVideo.connect(with: connectOptions, delegate: self)
//
//        logMessage(messageText: "Connecting to \(roomTextField.text ?? "a Room")")
//
//        self.showRoomUI(inRoom: true)
//        self.dismissKeyboard()
//    }
//
//    @IBAction func disconnect(sender: UIButton) {
//        if let room = self.room {
//            logMessage(messageText: "Disconnecting from \(room.name)")
//            room.disconnect()
//            sender.isEnabled = false
//            self.deleteCall(callID: self.callID ?? 0)
//        }
//
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        var bottomRight = CGPoint(x: view.bounds.width, y: view.bounds.height)
//        var layoutWidth = view.bounds.width
//        if #available(iOS 11.0, *) {
//            // Ensure the preview fits in the safe area.
//            let safeAreaGuide = self.view.safeAreaLayoutGuide
//            let layoutFrame = safeAreaGuide.layoutFrame
//            bottomRight.x = layoutFrame.origin.x + layoutFrame.width
//            bottomRight.y = layoutFrame.origin.y + layoutFrame.height
//            layoutWidth = layoutFrame.width
//        }
//
//        // Layout the speech label.
//        if let speechLabel = self.speechLabel {
//            speechLabel.preferredMaxLayoutWidth = layoutWidth - (kPreviewPadding * 2)
//
//            let constrainedSize = CGSize(width: view.bounds.width,
//                                         height: view.bounds.height)
//            let fittingSize = speechLabel.sizeThatFits(constrainedSize)
//            let speechFrame = CGRect(x: 0,
//                                     y: bottomRight.y - fittingSize.height - kTextBottomPadding,
//                                     width: view.bounds.width,
//                                     height: (view.bounds.height - bottomRight.y) + fittingSize.height + kTextBottomPadding)
//            speechLabel.frame = speechFrame.integral
//        }
//
//        // Layout the preview view.
//        if let previewView = self.camera?.previewView {
//            let dimensions = previewView.videoDimensions
//            var previewBounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160))
//            previewBounds = AVMakeRect(aspectRatio: CGSize(width: CGFloat(dimensions.width),
//                                                           height: CGFloat(dimensions.height)),
//                                       insideRect: previewBounds)
//
//            previewBounds = previewBounds.integral
//            previewView.bounds = previewBounds
//            previewView.center = CGPoint(x: bottomRight.x - previewBounds.width / 2 - kPreviewPadding,
//                                         y: bottomRight.y - previewBounds.height / 2 - kPreviewPadding)
//
//            if let speechLabel = self.speechLabel {
//                previewView.center.y = speechLabel.frame.minY - (2.0 * kPreviewPadding) - (previewBounds.height / 2.0);
//            }
//        }
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
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if (newCollection.horizontalSizeClass == .regular ||
//            (newCollection.horizontalSizeClass == .compact && newCollection.verticalSizeClass == .compact)) {
//            remoteViewStack.axis = .horizontal
//        } else {
//            remoteViewStack.axis = .vertical
//        }
//    }
//
//    // Update our UI based upon if we are in a Room or not
//    func showRoomUI(inRoom: Bool) {
//        self.connectButton.isHidden = inRoom
//        self.connectButton.isEnabled = !inRoom
//        self.roomTextField.isHidden = inRoom
//        self.roomLine.isHidden = inRoom
//        self.roomLabel.isHidden = inRoom
//        self.disconnectButton.isHidden = !inRoom
//        self.disconnectButton.isEnabled = inRoom
//        UIApplication.shared.isIdleTimerDisabled = inRoom
//        if #available(iOS 11.0, *) {
//            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
//        }
//        self.setNeedsStatusBarAppearanceUpdate()
//
//        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
//    }
//
//    func showSpeechRecognitionUI(view: UIView, message: String) {
//        // Create a dimmer view for the Participant being recognized.
//        let dimmer = UIView(frame: view.bounds)
//        dimmer.alpha = 0
//        dimmer.backgroundColor = UIColor(white: 1, alpha: 0.26)
//        dimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(dimmer)
//        self.dimmingView = dimmer
//
//        // Create a label which will be added to the stack and display recognized speech.
//        let messageLabel = UILabel()
//        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        messageLabel.textColor = UIColor.white
//        messageLabel.backgroundColor = UIColor(red: 226/255, green: 29/255, blue: 37/255, alpha: 1)
//        messageLabel.alpha = 0
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = NSTextAlignment.center
//
//        self.view.addSubview(messageLabel)
//        self.speechLabel = messageLabel
//
//        // Force a layout to position the speech label before animations.
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
//
//        UIView.animate(withDuration: 0.4, animations: {
//            self.view.setNeedsLayout()
//
//            messageLabel.text = message
//            dimmer.alpha = 1.0
//            messageLabel.alpha = 1.0
//            view.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
//            self.disconnectButton.alpha = 0
//
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func hideSpeechRecognitionUI(view: UIView) {
//        guard let dimmer = self.dimmingView else {
//            return
//        }
//
//        self.view.setNeedsLayout()
//
//        UIView.animate(withDuration: 0.4, animations: {
//            dimmer.alpha = 0.0
//            view.transform = CGAffineTransform.identity
//            self.speechLabel?.alpha = 0.0
//            self.disconnectButton.alpha = 1.0
//            self.view.layoutIfNeeded()
//        }, completion: { (complete) in
//            if (complete) {
//                self.speechLabel?.removeFromSuperview()
//                self.speechLabel = nil
//                dimmer.removeFromSuperview()
//                self.dimmingView = nil
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.view.setNeedsLayout()
//                    self.view.layoutIfNeeded()
//                })
//            }
//        })
//    }
//
//    override func dismissKeyboard() {
//        if (self.roomTextField.isFirstResponder) {
//            self.roomTextField.resignFirstResponder()
//        }
//    }
//
//    func logMessage(messageText: String) {
//        NSLog(messageText)
//        messageLabel.text = messageText
//
//        if (messageLabel.alpha < 1.0) {
//            self.messageLabel.isHidden = false
//            UIView.animate(withDuration: 0.4, animations: {
//                self.messageLabel.alpha = 1.0
//            })
//        }
//
//        // Hide the message with a delay.
//        self.messageTimer?.invalidate()
//        let timer = Timer(timeInterval: TimeInterval(6), repeats: false) { (timer) in
//            if (self.messageLabel.isHidden == false) {
//                UIView.animate(withDuration: 0.6, animations: {
//                    self.messageLabel.alpha = 0
//                }, completion: { (complete) in
//                    if (complete) {
//                        self.messageLabel.isHidden = true
//                    }
//                })
//            }
//        }
//
//        self.messageTimer = timer
//        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
//    }
//
//    // MARK:- Speech Recognition
//
//
//
//
//
//
//
//    func prepareLocalMedia() {
//
//        // We will share local audio and video when we connect to the Room.
//
//        // Create an audio track.
//        if (localAudioTrack == nil) {
//            localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
//
//            if (localAudioTrack == nil) {
//                logMessage(messageText: "Failed to create audio track")
//            }
//        }
//    }
//
//
////    func prepareLocalMedia() {
////        // Create an audio track.
////        localAudioTrack = TVILocalAudioTrack()
////        if (localAudioTrack == nil) {
////            logMessage(messageText: "Failed to create audio track!")
////            return
////        }
////
////        // Create a video track which captures from the front camera.
////        guard let frontCamera = CameraSource.captureDevice(position: .front) else {
////            logMessage(messageText: "Front camera is not available, using microphone only.")
////            return
////        }
////
////        // We will render the camera using CameraPreviewView.
////        let cameraSourceOptions = CameraSourceOptions() { (builder) in
////            builder.enablePreview = true
////        }
////
////        self.camera = TVICameraSource(options: cameraSourceOptions, delegate: self)
////        if let camera = self.camera {
////            localVideoTrack = LocalVideoTrack(source: camera)
////            logMessage(messageText: "Video track created.")
////
////            if let preview = camera.previewView {
////                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.recognizeLocalAudio))
////                preview.addGestureRecognizer(tap)
////                view.addSubview(preview);
////            }
////
////            camera.startCapture(device: frontCamera) { (captureDevice, videoFormat, error) in
////                if let error = error {
////                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
////                    self.camera?.previewView?.removeFromSuperview()
////                } else {
////                    // Layout the camera preview with dimensions appropriate for our orientation.
////                    self.view.setNeedsLayout()
////                }
////            }
////        }
////    }
//
////    func setupRemoteVideoView(publication: RemoteVideoTrackPublication) {
////        // Create a `VideoView` programmatically, and add to our `UIStackView`
////        if let remoteView = VideoView(frame: CGRect.zero, delegate:nil) {
////            // We will bet that a hash collision between two unique SIDs is very rare.
////            remoteView.tag = publication.trackSid.hashValue
////
////            // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit.
////            // scaleAspectFit is the default mode when you create `VideoView` programmatically.
////            remoteView.contentMode = .scaleAspectFit;
////
////            // Double tap to change the content mode.
////            let recognizerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.changeRemoteVideoAspect))
////            recognizerDoubleTap.numberOfTapsRequired = 2
////            remoteView.addGestureRecognizer(recognizerDoubleTap)
////
////            // Single tap to recognize remote audio.
////            let recognizerTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.recognizeRemoteAudio))
////            recognizerTap.require(toFail: recognizerDoubleTap)
////            remoteView.addGestureRecognizer(recognizerTap)
////
////            // Start rendering, and add to our stack.
////            publication.remoteTrack?.addRenderer(remoteView)
////            self.remoteViewStack.addArrangedSubview(remoteView)
////        }
////    }
//
////    func removeRemoteVideoView(publication: RemoteVideoTrackPublication) {
////        let viewTag = publication.trackSid.hashValue
////        if let remoteView = self.remoteViewStack.viewWithTag(viewTag) {
////            // Stop rendering, we don't want to receive any more frames.
////            publication.remoteTrack?.removeRenderer(remoteView as! VideoRenderer)
////            // Automatically removes us from the UIStackView's arranged subviews.
////            remoteView.removeFromSuperview()
////        }
////    }
//
//    @objc func changeRemoteVideoAspect(gestureRecognizer: UIGestureRecognizer) {
//        guard let remoteView = gestureRecognizer.view else {
//            print("Couldn't find a view attached to the tap recognizer. \(gestureRecognizer)")
//            return;
//        }
//
//        if (remoteView.contentMode == .scaleAspectFit) {
//            remoteView.contentMode = .scaleAspectFill
//        } else {
//            remoteView.contentMode = .scaleAspectFit
//        }
//    }
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
//}
//
//// MARK:- UITextFieldDelegate
//extension VoiceCallVC : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.connect(sender: textField)
//        return true
//    }
//}
//
//// MARK:- RoomDelegate
//extension VoiceCallVC : TVIRoomDelegate {
//
////    func didConnect(to room: TVIRoom) {
////
////        // At the moment, this example only supports rendering one Participant at a time.
////
////        //logMessage(messageText: "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
////
////        logMessage(messageText: "Connecting...")
////
////
////        // logMessage(messageText: "Please wait until \(self.selectedUserName!) accept your request...")
////
////        //Please wait until (user name) accept your request.
////
////
////    }
//
//    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
//        logMessage(messageText: "Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        print("Disconncted from room \(room.name), error = \(String(describing: error))")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//
//        self.navigationController?.popViewController(animated: true)
//
//        self.room = nil
//
////        self.showRoomUI(inRoom: false)
//        self.deleteCall(callID: self.callID ?? 0)
//    }
//
//    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
//        logMessage(messageText: "Failed to connect to room with error")
//
//
//        print(error)
//        print("Failed to connect to room with error")
//        self.room = nil
//
////        self.showRoomUI(inRoom: false)
//        self.deleteCall(callID: self.callID ?? 0)
//
//    }
//
//    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
//
//        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//
//
//    }
//
//    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
//
//        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
//        print("Room \(room.name), Participant \(participant.identity) disconnected")
//
//        UserDefaults.standard.set(nil , forKey: "voip")
//    }
//}
//
//// MARK:- RemoteParticipantDelegate
//extension VoiceCallVC : TVIRemoteParticipantDelegate {
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has offered to share the video Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
//        print("Participant \(participant.identity) published \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
//
//        // Remote Participant has stopped sharing the video Track.
//
//        //logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has offered to share the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
//        print("Participant \(participant.identity) published \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
//
//        // Remote Participant has stopped sharing the audio Track.
//
//        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//    }
//
//    func subscribed(to videoTrack: TVIRemoteVideoTrack,
//                    publication: TVIRemoteVideoTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's video frames now.
//
//        // logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//
//
//    }
//
//    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
//                      publication: TVIRemoteVideoTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
//        // remote Participant's video.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
//
//
//    }
//
//    func subscribed(to audioTrack: TVIRemoteAudioTrack,
//                    publication: TVIRemoteAudioTrackPublication,
//                    for participant: TVIRemoteParticipant) {
//
//        // We are subscribed to the remote Participant's audio Track. We will start receiving the
//        // remote Participant's audio now.
//
//        //logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        logMessage(messageText: "")
//
//        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//
//        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//
//
//    }
//
//    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
//                      publication: TVIRemoteAudioTrackPublication,
//                      for participant: TVIRemoteParticipant) {
//
//        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
//        // remote Participant's audio.
//
//        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
//        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
//    }
//
//    func remoteParticipant(_ participant: TVIRemoteParticipant,
//                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
//
//        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
//    }
//
//    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//    }
//
//    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
//                           error: Error,
//                           for participant: TVIRemoteParticipant) {
//        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//    }
//}
//
//// MARK: TVIVideoViewDelegate
//extension VoiceCallVC : TVIVideoViewDelegate {
//    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
//        self.view.setNeedsLayout()
//    }
//}
//
//
//// MARK: TVICameraCapturerDelegate
//extension VoiceCallVC : TVICameraCapturerDelegate {
//    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
//        logMessage(messageText: "Camera source failed with error: \(capturer.isCapturing)")
//
//    }
//}
//
