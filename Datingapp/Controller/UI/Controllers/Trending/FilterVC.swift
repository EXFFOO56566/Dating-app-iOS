
import UIKit
import WARangeSlider
import Async
import QuickdateSDK
import XLPagerTabStrip
class FilterVC: BaseVC {
    @IBOutlet weak var switcher: UISwitch!
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var bothBtn: UIButton!
    @IBOutlet weak var boysBtn: UIButton!
    @IBOutlet weak var girlsBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var onlineNowLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private let color = UIColor.Main_StartColor
    private var genderString:String? = ""
    var delegate:FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
        self.resetBtn.backgroundColor = .Button_StartColor
        self.switcher.onTintColor  = .Main_StartColor
        self.switcher.thumbTintColor  = .Main_StartColor
        self.rangeSlider.trackHighlightTintColor = .Main_StartColor
        distanceSlider.minimumTrackTintColor = .Main_StartColor
        self.filterLabel.text  = NSLocalizedString("Filter", comment: "Filter")
        self.locationLabel.text  = NSLocalizedString("Location", comment: "Location")
        self.countryLabel.text  = NSLocalizedString("NearBy", comment: "NearBy")
        self.lookingForLabel.text = NSLocalizedString("Who are you looking for?", comment: "Who are you looking for?")
        self.girlsBtn.setTitle(NSLocalizedString("GIRLS", comment: "GIRLS"), for: .normal)
        self.boysBtn.setTitle(NSLocalizedString("BOYS", comment: "BOYS"), for: .normal)
        self.girlsBtn.setTitle(NSLocalizedString("BOTH", comment: "BOTH"), for: .normal)
        self.ageLabel.text = NSLocalizedString("Age", comment: "Age")
         self.minLabel.text = NSLocalizedString("Min", comment: "Min")
         self.maxLabel.text = NSLocalizedString("Max", comment: "Max")
         self.distanceLabel.text = NSLocalizedString("Distance", comment: "Distance")
          self.onlineNowLabel.text = NSLocalizedString("Online Now", comment: "Online Now")
        self.resetBtn.setTitle(NSLocalizedString("Reset filter", comment: "Reset filter"), for: .normal)
        self.genderString = "male"
        self.girlsBtn.backgroundColor = color
        self.girlsBtn.setTitleColor(.white, for: .normal)
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    override func viewWillLayoutSubviews() {
        self.bothBtn.circleView()
        self.boysBtn.circleView()
        self.girlsBtn.circleView()
    }
    @IBAction func selectCountryPressed(_ sender: Any) {
        let vc = R.storyboard.popUps.languagePopUpVC()
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func bothPressed(_ sender: Any) {
        self.bothBtn.backgroundColor = color
        self.bothBtn.setTitleColor(.white, for: .normal)
        
        self.boysBtn.backgroundColor = .clear
        self.boysBtn.setTitleColor(.label, for: .normal)
        
        self.girlsBtn.backgroundColor = .clear
        self.girlsBtn.setTitleColor(.label, for: .normal)
        self.genderString = "both"
        AppInstance.instance.gender = self.genderString
    }
    
    @IBAction func boysPressed(_ sender: Any) {
        self.boysBtn.backgroundColor = color
        self.boysBtn.setTitleColor(.white, for: .normal)
        
        self.bothBtn.backgroundColor = .clear
        self.bothBtn.setTitleColor(.label, for: .normal)
        
        self.girlsBtn.backgroundColor = .clear
        self.girlsBtn.setTitleColor(.label, for: .normal)
        self.genderString = "male"
        AppInstance.instance.gender = self.genderString
    }
    
    @IBAction func applyFilter(_ sender: Any) {
//        self.filter()
    }
    @IBAction func resetFilter(_ sender: Any) {
        self.rangeSlider.lowerValue = 0
        self.rangeSlider.upperValue = 100
        self.countryLabel.text = "NearBy"
        
    }
    @IBAction func girlPressed(_ sender: Any) {
        self.girlsBtn.backgroundColor = color
        self.girlsBtn.setTitleColor(.white, for: .normal)
        
        self.boysBtn.backgroundColor = .clear
        self.boysBtn.setTitleColor(.label, for: .normal)
        
        self.bothBtn.backgroundColor = .clear
        self.bothBtn.setTitleColor(.label, for: .normal)
        self.genderString = "female"
        AppInstance.instance.gender = self.genderString
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        log.verbose("Slider changing to \(currentValue) ?")
        Async.main({
            self.distanceLabel.text = "\(currentValue) Km"
            AppInstance.instance.distance = currentValue
        })
    }
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        self.ageLabel.text = "\(Int(rangeSlider.lowerValue)) - \(Int(rangeSlider.upperValue))"
        AppInstance.instance.ageMax = Int(rangeSlider.upperValue)
        AppInstance.instance.ageMin = Int(rangeSlider.lowerValue)
        
    }
    

}
extension FilterVC:didSelectCountryDelegate{
    func selectCountry(status: Bool, countryString: String) {
        self.countryLabel.text = countryString
        AppInstance.instance.loction = countryString
    }
    
    
}
extension FilterVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("BASICS", comment: "BASICS"))
    }
}
