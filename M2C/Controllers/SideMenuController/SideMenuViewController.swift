//
//  SideMenuViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/08/2022.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var txtVersion: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableViewSideMenu: UITableView!
    
    // MARK: VARIABLES
    
    
    
    // MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Global.shared.loginUser?.roleName == "Coach"{
            SideMenuConstants.arrSideMenu[1].title = "Strikers"
        }else{
            SideMenuConstants.arrSideMenu[1].title = "Coaches"
        }
        SideMenuConstants.arrSideMenu.forEach({$0.isHidden = true})
        self.txtVersion.text = "V " + (Bundle.main.releaseVersionNumber ?? "") + "(" + (Bundle.main.buildVersionNumber ?? "") + ")"
        self.tableViewSideMenu.delegate = self
        self.tableViewSideMenu.dataSource = self
        self.tableViewSideMenu.rowHeight = UITableView.automaticDimension
        self.tableViewSideMenu.estimatedRowHeight = 100
        self.tableViewSideMenu.registerSingleCell(cellType: SideMenuCell.self)
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: HELPERS
    func setupUI() {
        self.hideNavigationBar()
    }

    @IBAction func btnLogoutClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            let params = ["loggedUserId": Global.shared.loginUser?.userId ?? ""]
            
            serverRequest.delegate = self
            serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.logout, params: params, method: .post, type: "logout", loading: true, headerType: .headerWithAuth)
        })
    }
    
    
}

// MARK: TABLE VIEW METHODS
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuConstants.arrSideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(with: SideMenuCell.self, for: indexPath)
        
        cell.setupCell(sideMenu: SideMenuConstants.arrSideMenu[indexPath.row])
        if indexPath.row == SideMenuConstants.arrSideMenu.count - 1{
            cell.viewSeparator.hide()
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // For My Dashboard
        if indexPath.row == 0{
            self.dismiss(animated: true)
        }
        // For Edit Profile
//        else if indexPath.row == 1{
//            let vc = ProfileVC.initFrom(storyboard: .dashboard)
//            self.pushViewController(vc: vc)
//        }
        
        // For Coaches/Strikers
        else if indexPath.row == 1{
            
            if let user = Global.shared.loginUser{
                // If subscription is active
                if user.isSubscriptionActive{
                    
                    let expandableStriker = SideMenuConstants.arrSideMenu[indexPath.row]
                    expandableStriker.isHidden = !(expandableStriker.isHidden)
                    tableViewSideMenu.reloadRows(at: [indexPath], with: .automatic)
                    
                    if Global.shared.loginUser?.roleName == "Coach"{
                        
                        // To open strikers list
        //                let expandableStriker = SideMenuConstants.arrSideMenu[indexPath.row]
        //                expandableStriker.isHidden = !(expandableStriker.isHidden)
        //                tableViewSideMenu.reloadRows(at: [indexPath], with: .automatic)
                        
                    } else{
                        
                    }
                }else{
                    // If subscription is not active
                    self.dismiss(animated: true)
                }
            }
            
        }
        // For Settings
        else if indexPath.row == 2{
            let vc = SettingsViewController.initFrom(storyboard: .dashboard)
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            navController.hideNavigationBar()
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !SideMenuConstants.arrSideMenu[indexPath.row].isHidden{
            if Global.shared.loginUser?.roleName == "Coach"{
                return 155
            }else{
                if Global.shared.loginUser!.isGuest{
                    // If user is a striker and a guest as well
                    return 90
                }else{
                    // If user is striker but not a guest
                    return 120
                }
            }
            
        }
        return UITableView.automaticDimension
    }
}

// MARK: Side Menu Protocol
extension SideMenuViewController: SideMenuProtocol{
    
    func allStrikersClicked() {
        print("All Strikers clicked")
        let vc = StrikersListViewController.initFrom(storyboard: .dashboard)
        self.pushViewController(vc: vc)
    }
    
    func connectStrikerClicked() {
        print("Connect Striker clicked")
        let vc = SendInviteViewController.initFrom(storyboard: .dashboard)
        vc.mode = "Striker"
        self.pushViewController(vc: vc)
    }
    
    func inviteStrikerClicked() {
        print("Invite Striker clicked")
        let vc = GuestInviteViewController.initFrom(storyboard: .dashboard)
        self.pushViewController(vc: vc)
    }
    
    func allCoachesClicked() {
        print("All Coaches clicked")
        let vc = CoachesListViewController.initFrom(storyboard: .dashboard)
        self.pushViewController(vc: vc)
    }
    
    func connectCoachClicked() {
        print("Connect Coach clicked")
        let vc = SendInviteViewController.initFrom(storyboard: .dashboard)
        vc.mode = "Coach"
        self.pushViewController(vc: vc)
    }
    
}


// MARK: SERVER RESPONSE
extension SideMenuViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "logout"{
            userDefault.deleteValue(key: UDKey.savedUser)
            userDefault.deleteValue(key: UDKey.videoWeight)
            userDefault.deleteValue(key: UDKey.videoHeight)
            userDefault.deleteValue(key: UDKey.isRecordingWeightAdded)
            Global.shared.selectedStriker = nil
            
            AppDelegate.app.moveToLogin()
        }
    }
}

