//
//  SideMenuVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 19/05/2022.
//

import UIKit

class SideMenuVC: BaseVC {

    @IBOutlet weak var lblPoweredBy: UILabel!
    @IBOutlet weak var tblMenus: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        // create attributed string
      
        self.lblPoweredBy.attributedText = NSMutableAttributedString()
            .normal("Powered by ")
            .blueForeground("Fenris Group\n")
            .normal("Version \(versionNumber)")
            
        self.tblMenus.delegate = self
        self.tblMenus.dataSource = self
        self.tblMenus.reloadData()
    }
    
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
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
extension SideMenuVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menusOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVCell", for: indexPath) as! SideMenuTVCell
        if(indexPath.row == (menusOptions.count - 1)){
            cell.separator.isHidden = true
        }
        cell.imgIcon.image = UIImage(named: sideMenuImages[indexPath.row])
        cell.lblTitle.text = menusOptions[indexPath.row]
//        if(indexPath.row != 2){
//
//        }
        
//        cell.config(title: menusOptions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            self.navigateForward(storyBoard: SBDashboard, viewController: profileVCID)
        case 1:
            
            let vc = ProfileVC.initFrom(storyboard: .dashboard)
            self.pushViewController(vc: vc)
        case 2:
            print("logout")
        default:
            print("None of the provided Menus")
        }
    }
    
    
    
}
