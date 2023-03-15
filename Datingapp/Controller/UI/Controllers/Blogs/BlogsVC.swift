

import UIKit
import Async
import QuickdateSDK
class BlogsVC: BaseVC {

    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var blogsArray = [BlogsModel.Datum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchBlogs()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
  
        self.navigationController?.popViewController(animated: true)
        
    }
    private func setupUI(){
        self.exploreLabel.text = NSLocalizedString("Explore Articles", comment: "Explore Articles")
//        self.title = "Explore Articles"
        self.tableView.separatorStyle = .none
        self.tableView.register(R.nib.blogsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.blogsTableCell.identifier)
    }
    private func fetchBlogs(){
        self.showProgressDialog(text: "Loading...")
        if Connectivity.isConnectedToNetwork(){
            
            let accessToken = AppInstance.instance.accessToken ?? ""
            Async.background({
                BlogsManager.instance.getBlogs(AccessToken: accessToken, limit: 20, offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.blogsArray = success?.data ?? []
                                self.tableView.reloadData()
                                
                               
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

extension BlogsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blogsTableCell.identifier) as? BlogsTableCell
        let object = self.blogsArray[indexPath.row]
        cell?.titleLabel.text = object.title ?? ""
        cell?.timeLabel.text = ""
        cell?.descriptionlabel.text = object.datumDescription?.htmlAttributedString ?? ""
        cell?.blogCategoryLabel.text = object.categoryName ?? ""
        
        if let avatarURL = URL(string: object.thumbnail ?? "") {
            cell?.blogImage.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            cell?.blogImage.image = UIImage(named: "no_profile_image")
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = R.storyboard.blogs.showBlogVC()
        vc?.htmlString = self.blogsArray[indexPath.row].content ?? ""
        vc?.locationURL = self.blogsArray[indexPath.row].url ?? ""
        vc?.object = self.blogsArray[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
