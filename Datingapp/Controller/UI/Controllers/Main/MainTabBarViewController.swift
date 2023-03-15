
import UIKit
import Async


class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .Main_StartColor
        let url = URL(string: AppInstance.instance.userProfile?.data?.avater ?? "")
        Async.background({
            
            if url == nil{
                Async.main({
                  self.tabBar.items![4].image = R.image.tab_profile_ic()
                })
               
            }else{
                let data = try? Data(contentsOf: url!)
                Async.main({
                    self.tabBar.items![4].image  =  self.resizeImage(image: UIImage(data: data!)!, targetSize: CGSize(width: 30, height: 30))?.withRenderingMode(.alwaysOriginal)
                })
            }
        })
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
