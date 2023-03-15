

import UIKit
import Async
import QuickdateSDK
import GoogleMobileAds

class EditFavouritesVC: BaseVC {
    
    @IBOutlet weak var dishTextFIeld: UITextField!
    @IBOutlet weak var tvShowTextField: UITextField!
    @IBOutlet weak var colorTextFIeld: UITextField!
    @IBOutlet weak var movieTextField: UITextField!
    @IBOutlet weak var bookTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var hobbyTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var musicTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
  
    @IBAction func savePressed(_ sender: Any) {
        updateFavourites()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
         self.saveBtn.backgroundColor = .Button_StartColor
        if ControlSettings.shouldShowAddMobBanner{

                              bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                              addBannerViewToView(bannerView)
                              bannerView.adUnitID = ControlSettings.addUnitId
                              bannerView.rootViewController = self
                              bannerView.load(GADRequest())
                            
                          }
        self.favoriteLabel.text = NSLocalizedString("Favorite Info", comment: "Favorite Info")
        self.musicTextField.placeholder = NSLocalizedString("Music", comment: "Music")
        self.dishTextFIeld.placeholder = NSLocalizedString("Dish", comment: "Dish")
        self.songTextField.placeholder = NSLocalizedString("Song", comment: "Song")
          self.hobbyTextField.placeholder = NSLocalizedString("Hobby", comment: "Hobby")
          self.cityTextField.placeholder = NSLocalizedString("City", comment: "City")
         self.sportTextField.placeholder = NSLocalizedString("Sport", comment: "Sport")
         self.bookTextField.placeholder = NSLocalizedString("Book", comment: "Book")
         self.movieTextField.placeholder = NSLocalizedString("Movie", comment: "Movie")
          self.colorTextFIeld.placeholder = NSLocalizedString("Color", comment: "Color")
         self.tvShowTextField.placeholder = NSLocalizedString("Tv Show", comment: "Tv Show")
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        
        let userData =  AppInstance.instance.userProfile?.data
        self.musicTextField.text = userData?.music ?? ""
        self.dishTextFIeld.text = userData?.dish ?? ""
        self.songTextField.text = userData?.song ?? ""
        self.hobbyTextField.text = userData?.hobby ?? ""
        self.cityTextField.text = userData?.city ?? ""
        self.sportTextField.text  = userData?.sport ?? ""
        self.bookTextField.text = userData?.book ?? ""
        self.movieTextField.text = userData?.movie ?? ""
        self.colorTextFIeld.text = userData?.colour ?? ""
        self.tvShowTextField.text = userData?.tv ?? ""
        
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(bannerView)
                view.addConstraints(
                    [NSLayoutConstraint(item: bannerView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: bottomLayoutGuide,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 0),
                     NSLayoutConstraint(item: bannerView,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .centerX,
                                        multiplier: 1,
                                        constant: 0)
                    ])
            }
    private func updateFavourites(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(text: "Loading...")
            let accessToken = AppInstance.instance.accessToken ?? ""
            let music  = self.musicTextField.text ?? ""
            let dish = self.dishTextFIeld.text ?? ""
            let song = self.songTextField.text ?? ""
            let hobby = self.hobbyTextField.text ?? ""
            let city = self.cityTextField.text ?? ""
            let sport = self.sportTextField.text ?? ""
            let book = self.bookTextField.text ?? ""
            let movie = self.movieTextField.text ?? ""
            let color = self.colorTextFIeld.text ?? ""
            let tvShow = self.tvShowTextField.text ?? ""
            Async.background({
                ProfileManger.instance.editFavourite(AccessToken: accessToken, Music: music, Dish: dish, Song: song, Hobby: hobby, City: city, Sport: sport, Book: book, Movie: movie, Color: color, Tvshow: tvShow, completionBlock: { (success, sessionError, error) in
                     if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")

                                AppInstance.instance.fetchUserProfile(view: self.view, completionBlock: {
                                    log.debug("FetchUserProfile Fetched)")
                                })
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                log.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
              
            })
            
        }else{
            log.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
}
