

import UIKit
import Async
import SwiftEventBus
import QuickdateSDK
class SplashScreenVC: BaseVC {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            log.verbose("Internet connected!")
            self.showStack.isHidden = false
            self.activityIndicator.startAnimating()
            self.fetchUserProfile()
            
        }
        
        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
            self.showStack.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        self.fetchUserProfile()
    }
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    
    private func fetchUserProfile(){
        if appDelegate.isInternetConnected{
            self.activityIndicator.startAnimating()
            let status = AppInstance.instance.getUserSession()
            if status{
                if (AppInstance.instance.accessToken == "") || (AppInstance.instance.accessToken == nil){
                    SwiftEventBus.unregister(self)
                    let mainNav =  R.storyboard.authentication.main()
                    self.appDelegate.window?.rootViewController = mainNav
                }
                else{
                let userId = AppInstance.instance.userId ?? 0
                let accessToken = AppInstance.instance.accessToken ?? ""
                Async.background({
                    ProfileManger.instance.getProfile(UserId: userId, AccessToken: accessToken, FetchString: "data,media,likes,blocks,payments,reports,visits", completionBlock: { (success, sessionError, error) in
                        if success != nil{
                            Async.main({
                                
                                AppInstance.instance.userProfile = success ?? nil
                                SwiftEventBus.unregister(self)
                                self.showStack.isHidden = true
                                
                                self.activityIndicator.stopAnimating()
                                let dashboardNav =  R.storyboard.main.mainTabBarViewController()
                                dashboardNav?.modalPresentationStyle = .fullScreen
                                self.present(dashboardNav!, animated: true, completion: nil)
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.activityIndicator.stopAnimating()
                                self.showStack.isHidden = true
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.view.makeToast(sessionError?.errors?.errorText)
                            })
                            
                        }else {
                            Async.main({
                                self.activityIndicator.stopAnimating()
                                self.showStack.isHidden = true
                                log.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription)
                            })
                        }
                        
                    })
                })
            }
                
            }else{
                SwiftEventBus.unregister(self)
                let mainNav =  R.storyboard.authentication.main()
                self.appDelegate.window?.rootViewController = mainNav
            }
        }else {
            self.view.makeToast(InterNetError)
        }
    }
}

