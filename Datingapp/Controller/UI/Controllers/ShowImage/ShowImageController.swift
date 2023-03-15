//
//  ShowImageController.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/13/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import SDWebImage

class ShowImageController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: self.imageUrl)
        self.imageView.sd_setImage(with: url)
        // Do any additional setup after loading the iew.
    }
    
    @IBAction func Back(_ sender: Any) {
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
