//
//  StartVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import QuickdateSDK
class StartVC: UIViewController {

    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet var firstImage1: UIImageView!
    @IBOutlet var firstImage2: UIImageView!
    @IBOutlet var heartImageView: UIView!
    @IBOutlet var heartImage: UIImageView!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var buttonRegister: UIButton!
    @IBOutlet var backgroundColoredView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigation(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         hideNavigation(hide: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
//        buttonLogin.setGradientBackground(colorOne: UIColor(red: 100/255, green: 38/255, blue: 92/255, alpha: 1.0), colorTwo: UIColor(red: 167/255, green: 49/255, blue: 160/255, alpha: 1.0), horizontal: true)
//        buttonRegister.setGradientBackground(colorOne: UIColor(red: 100/255, green: 38/255, blue: 92/255, alpha: 1.0), colorTwo: UIColor(red: 167/255, green: 49/255, blue: 160/255, alpha: 1.0), horizontal: true)
        backgroundColoredView.halfCircleView()
        buttonLogin.setGradientBackground(colorOne: UIColor.Button_StartColor, colorTwo: UIColor.Button_EndColor, horizontal: true)
        buttonRegister.setGradientBackground(colorOne: UIColor.Button_StartColor, colorTwo: UIColor.Button_EndColor, horizontal: true)
        buttonLogin.setTitleColor(.Button_TextColor, for: .normal)
        buttonRegister.setTitleColor(.Button_TextColor, for: .normal)
        

    }
    
    //MARK: - Setting views
    func setupUI() {
        self.topLabel.text = NSLocalizedString("Swipe right to like someone and if you both like each other? Its a match.", comment: "Swipe right to like someone and if you both like each other? Its a match.")
        self.buttonRegister.setTitle(NSLocalizedString("Register", comment: "Register"), for: .normal)
        
        self.buttonLogin.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        bottonLabel.text = NSLocalizedString("Flirt, Chat, and meet people around you.", comment: "Flirt, Chat, and meet people around you.")
        
        firstImage1.circleView()
        firstImage2.circleView()
        heartImageView.circleView()
        heartImage.circleView()
        buttonLogin.layer.cornerRadius = buttonLogin.frame.size.height / 2
        buttonRegister.layer.cornerRadius = buttonRegister.frame.size.height / 2
        viewDidLayoutSubviews()
    }

    //MARK: - Actions
    @IBAction func buttonLoginAction(_ sender: Any) {
        // push to Login VC
       let vc = R.storyboard.authentication.loginVC()
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func buttonRegisterAction(_ sender: Any) {
        
        // push to SignUp VC
        let vc = R.storyboard.authentication.registerVC()
        navigationController?.pushViewController(vc!, animated: true)
     
    }
}
