
import UIKit
import Foundation

public extension UIViewController {
    
    func showNavigation(title: String, shadow: Bool = true, background: UIImage = UIImage()) {
        
        self.title = title
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .Main_StartColor
        navigationController?.navigationBar.setBackgroundImage(background, for: UIBarMetrics.default)
        if !shadow {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    func hideNavigation(hide: Bool) {
        
        navigationController?.setNavigationBarHidden(hide, animated: false)
    }
    
    func setNavigationButtons(left: [UIBarButtonItem] = [], right: [UIBarButtonItem] = []) {
        
        navigationItem.setRightBarButtonItems(right, animated: false)
        navigationItem.setLeftBarButtonItems(left, animated: false)
    }
    
//    func showAlert(type: AlertType, title: String, message: String, action: @escaping ()->()) {
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        if type == .confirm {
//            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(actionCancel)
//            let actionOK = UIAlertAction(title: "OK", style: .default) { (_) in
//                action()
//            }
//            alert.addAction(actionOK)
//        } else if type == .error {
//            let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(actionOK)
//        }
//        present(alert, animated: true, completion: nil)
//    }
}
