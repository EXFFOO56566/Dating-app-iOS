

import UIKit
import WebKit
class ShowBlogVC: UIViewController {
    
    @IBOutlet weak var tableVIew: UITableView!
    var htmlString:String? = ""
    var locationURL:String? = ""
    var object:BlogsModel.Datum? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    private func setupUI(){
        //        webView.loadHTMLString(self.htmlString?.htmlAttributedString ?? "", baseURL: nil)
        self.tableVIew.register( R.nib.showBlogSectionOneTableItem(), forCellReuseIdentifier: R.reuseIdentifier.showBlogSectionOneTableItem.identifier)
        self.tableVIew.register( R.nib.showBlogSectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.showBlogSectionTwoTableItem.identifier)
        self.tableVIew.register( R.nib.blogViewTableItem(), forCellReuseIdentifier: R.reuseIdentifier.blogViewTableItem.identifier)
    }
    
}
extension ShowBlogVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showBlogSectionOneTableItem.identifier) as? ShowBlogSectionOneTableItem
            cell?.bind(object!)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showBlogSectionTwoTableItem.identifier) as? ShowBlogSectionTwoTableItem
            cell!.vc = self
            cell?.bind(object!)
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blogViewTableItem.identifier) as? BlogViewTableItem
            cell!.vc = self
            cell?.bind(object!)
            return cell!
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 80.0
        default:
            return UITableView.automaticDimension
        }
    }
}
