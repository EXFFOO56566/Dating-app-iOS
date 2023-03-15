//
//  SessionTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/29/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import Async

class SessionTableItem: UITableViewCell {
    

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var lastSeenlabel: UILabel!
    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var object : SessionModel.Datum?
    
    var singleCharacter :String?
    var indexPath:Int? = 0
    var vc:SessionsVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cancelBtn.backgroundColor = .Button_StartColor
        self.bgView.backgroundColor = .Main_StartColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object:SessionModel.Datum, index:Int){
        self.object = object
        self.indexPath = index
        self.phoneLabel.text = "\(NSLocalizedString("Phone", comment: "Phone")) : \(object.os ?? "")"
        self.browserLabel.text = "\(NSLocalizedString("Browser", comment: "Browser")) : \(object.platform ?? "")"
        self.phoneLabel.text = "\(NSLocalizedString("Last seen", comment: "Last seen")) : \(object.timeText ?? "")"
        if object.platform == nil{
            self.alphaLabel.text = self.singleCharacter ?? ""
        }else{
            for (index, value) in (object.platform?.enumerated())!{
                if index == 0{
                    self.singleCharacter = String(value)
                    break
                }
            }
            self.alphaLabel.text = self.singleCharacter ?? ""
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.deleteSession()
        
    }
    private func deleteSession(){
        let id = self.object?.id ?? 0
        let accessToken = AppInstance.instance.accessToken ?? ""
        
        Async.background({
            SessionManager.instance.deleteSession(AccessToken: accessToken, id: id) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        
                        self.vc?.sessionArray.remove(at: self.indexPath ?? 0)
                        self.vc?.tableView.reloadData()
                        
                        
                    })
                }else if sessionError != nil{
                    Async.main({
                        
                        self.vc!.view.makeToast(sessionError?.errors?.errorText ?? "")
                        log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        
                        
                    })
                }else {
                    Async.main({
                        
                        self.vc!.view.makeToast(error?.localizedDescription ?? "")
                        log.error("error = \(error?.localizedDescription ?? "")")
                        
                    })
                }
            }
            
            
        })
        
    }
    
}

