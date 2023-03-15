

import UIKit

class ProfileEditPopUpVC: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var type:String? = ""
    var language:GetSettingsModel.DataClass?
    var loadingArray = [String]()
    var HeightKeysArray = [String]()
    var delegate:didSetProfilesParamDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    private func setupUI(){
        self.tableView.separatorStyle = .none
       
        self.typeLabel.text = type
        if self.type == "Language"{
            AppInstance.instance.settings?.language?.forEach({ (it) in
                it.keys.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
        }else if self.type == "Relationship"{
            AppInstance.instance.settings?.relationship?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
            
        }else if self.type == "Work Status"{
            AppInstance.instance.settings?.workStatus?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
            
        }else if self.type == "Education"{
            AppInstance.instance.settings?.education?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
        }else if self.type == "Ethnicity"{
            AppInstance.instance.settings?.ethnicity?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
        }else if self.type == "Body"{
            AppInstance.instance.settings?.body?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
            })
        }else if self.type == "Height"{
            AppInstance.instance.settings?.height?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                it.keys.forEach({ (it2) in
                    self.HeightKeysArray.append(it2)
                })
            })
        }else if self.type == "Character"{
            AppInstance.instance.settings?.character?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
               
            })
        }else if self.type == "Children"{
            AppInstance.instance.settings?.children?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
              
            })
        }else if self.type == "Friends"{
            AppInstance.instance.settings?.friends?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
               
            })
        }else if self.type == "Pet"{
            AppInstance.instance.settings?.pets?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
               
            })
        }else if self.type == "Live With"{
            AppInstance.instance.settings?.liveWith?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "Car"{
            AppInstance.instance.settings?.car?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "Religion"{
            AppInstance.instance.settings?.religion?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "Smoke"{
            AppInstance.instance.settings?.smoke?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "Drink"{
            AppInstance.instance.settings?.drink?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "Travel"{
            AppInstance.instance.settings?.travel?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                
            })
        }else if self.type == "fromHeight"{
            AppInstance.instance.settings?.height?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                it.keys.forEach({ (it2) in
                    self.HeightKeysArray.append(it2)
                })
            })
        }else if self.type == "toHeight"{
            AppInstance.instance.settings?.height?.forEach({ (it) in
                it.values.forEach({ (it1) in
                    self.loadingArray.append(it1)
                })
                it.keys.forEach({ (it2) in
                    self.HeightKeysArray.append(it2)
                })
            })
        }
    }
  
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension  ProfileEditPopUpVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return  self.loadingArray.count
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell
        cell?.selectionStyle = .none
        cell?.textLabel!.text = self.loadingArray[indexPath.row].htmlAttributedString ?? ""
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            if self.type == "Height"{
                self.delegate?.setProfileParam(status: true, selectedString: self.loadingArray[indexPath.row].htmlAttributedString ?? "", Type: self.type ?? "",index: self.HeightKeysArray[indexPath.row].toInt()!)
            }else{
                self.delegate?.setProfileParam(status: true, selectedString: self.loadingArray[indexPath.row].htmlAttributedString ?? "", Type: self.type ?? "",index:indexPath.row + 1)
            }
            
        }
        
    }
    
    
}
