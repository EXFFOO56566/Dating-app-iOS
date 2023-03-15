//
//  TutorialViewVC.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 8/31/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class TutorialViewVC: UIViewController {
    
    @IBOutlet weak var letsEasyLabel: UILabel!
    @IBOutlet var tutorialView: UIView!
    @IBOutlet var tutorialBgrView: UIView!
    @IBOutlet var tutorialContentLabel: UILabel!
    @IBOutlet var tutorialIcon: UIImageView!
    @IBOutlet var skipTutorialButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    var delegate:dismissTutorialViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    private func setupUI(){
        self.letsEasyLabel.text = NSLocalizedString("Let's Easy", comment: "Let's Easy")
        self.tutorialContentLabel.text = NSLocalizedString("If you like this person and keep in touch, Swipe Right", comment: "If you like this person and keep in touch, Swipe Right")
        self.skipTutorialButton.setTitle(NSLocalizedString("Skip Tutorial", comment: "Skip Tutorial"), for: .normal)
        
         self.nextButton.setTitle(NSLocalizedString("Next", comment: "Next"), for: .normal)
        
    }
    override func viewDidLayoutSubviews() {
        tutorialBgrView.setGradientBackground(colorOne: UIColor.Main_StartColor, colorTwo: UIColor.Main_EndColor, horizontal: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if skipTutorialButton.isHidden {
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
                self?.tutorialView.alpha = 0
            }) { [weak self](_) in
                UserDefaults.standard.setShowHideView(value: true, ForKey: "showHide")
                
                self?.tutorialView.removeFromSuperview()
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.dismissTutorialView(status: true)
                })
                
            }
        } else {
            UIView.transition(with: tutorialBgrView, duration: 0.5, options: .transitionCrossDissolve, animations: {[weak self] in
                self?.tutorialContentLabel.text = NSLocalizedString("If you dislike this person and you don't want to keep in touch Swipe Left", comment: "If you dislike this person and you don't want to keep in touch Swipe Left")
                self?.tutorialIcon.image = UIImage(named: "tutorial_ic_2")
                self?.skipTutorialButton.isHidden = true
                
                self?.nextButton.setTitle("Finish", for: .normal)
                self?.nextButton.setTitleColor(UIColor.white, for: .normal)
                self?.nextButton.backgroundColor = UIColor.clear
                self?.nextButton.layer.borderWidth = 1
                self?.nextButton.layer.borderColor = UIColor.white.cgColor
                }, completion: nil)
        }
    }
    
    @IBAction func skipTutorialButtonAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.tutorialView.alpha = 0
        }) { [weak self](_) in
            UserDefaults.standard.setShowHideView(value: true, ForKey: "showHide")
            
            self?.tutorialView.removeFromSuperview()
            self?.dismiss(animated: true, completion: {
                self?.delegate?.dismissTutorialView(status: true)
            })
        }
    }
}
