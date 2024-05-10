//
//  SettingsViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/08/2022.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtRole: UILabel!
    @IBOutlet weak var viewConnectStriker: UIView!
    @IBOutlet weak var txtVersion: UILabel!
    @IBOutlet weak var viewConnectCoach: UIView!
    @IBOutlet weak var viewConnectGuest: UIView!
    
    //MARK: VARIABLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBar()
//        self.setupUI()
        
        
        if let user = Global.shared.loginUser{
            if user.roleName == "Coach"{
                self.viewConnectCoach.hide()
            }else{
                self.viewConnectStriker.hide()
                self.viewConnectGuest.hide()
            }
            
//            if user.isGuest{
//                self.viewConnectStriker.hide()
//                self.viewConnectGuest.hide()
//                self.viewConnectCoach.hide()
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    //MARK: HELPERS
    private func setupUI(){
        
        self.imgProfile.downloadImage(imageUrl: Global.shared.loginUser?.picturePath, placeHolder: "smProfile")
        self.txtRole.text = Global.shared.loginUser?.roleName
        let name: String = (Global.shared.loginUser?.firstName ?? "") + " " + (Global.shared.loginUser?.lastName ?? "")
        txtName.text = name
        txtVersion.text = "V " + (Bundle.main.releaseVersionNumber ?? "") + "(" + (Bundle.main.buildVersionNumber ?? "") + ")"
    }
    
    //MARK: ACTIONS
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnEditProfileClicked(_ sender: Any) {
        let vc = ProfileVC.initFrom(storyboard: .dashboard)
        self.pushViewController(vc: vc)
    }
    
    @IBAction func btnNotificationsClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnContactUsClicked(_ sender: Any) {
        if let url = URL(string: "https://www.motion2coach.com/contact-us"){
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        
    }
    
    @IBAction func btnSettingsPrivacyClicked(_ sender: Any) {
        let vc = SettingsAndPrivacyViewController.initFrom(storyboard: .dashboard)
        self.present(vc, animated: true)
    }
    
    @IBAction func btnConnectGuestClicked(_ sender: Any) {
//        let vc = GuestInviteViewController.initFrom(storyboard: .dashboard)
//        self.pushViewController(vc: vc)
    }
    
    
    @IBAction func btnAboutClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnHelpClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnConnectWithCoachClicked(_ sender: Any) {
        let vc = SendInviteViewController.initFrom(storyboard: .dashboard)
        vc.mode = "Coach"
        self.pushViewController(vc: vc)
    }
    
    @IBAction func btnConnectWithStrikerClicked(_ sender: Any) {
        let vc = SendInviteViewController.initFrom(storyboard: .dashboard)
        vc.mode = "Striker"
        self.pushViewController(vc: vc)
    }
    
    @IBAction func btnDeleteAccountClicked(_ sender: Any) {
//        let vc = DeleteAccountPasswordViewController.initFrom(storyboard: .dashboard)
//        self.pushViewController(vc: vc)
    }
}
