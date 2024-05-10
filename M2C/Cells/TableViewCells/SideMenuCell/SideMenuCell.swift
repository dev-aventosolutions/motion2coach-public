//
//  SideMenuCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/08/2022.
//

import UIKit

protocol SideMenuProtocol: AnyObject{
    func allStrikersClicked()
    func connectStrikerClicked()
    func inviteStrikerClicked()
    func allCoachesClicked()
    func connectCoachClicked()
}

class SideMenuCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var stackViewButtons: UIStackView!{
        didSet{
            stackViewButtons.isHidden = true
        }
    }
    @IBOutlet weak var imgExpand: UIImageView!
    @IBOutlet weak var viewAllStrikers: UIView!
    @IBOutlet weak var viewConnectStriker: UIView!
    @IBOutlet weak var viewInviteStriker: UIView!
    @IBOutlet weak var viewAllCoaches: UIView!
    @IBOutlet weak var viewConnectCoach: UIView!
    
    
    var delegate: SideMenuProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(sideMenu: SideMenu){
        self.titleLabel.text = sideMenu.title
        self.iconImageView.image = UIImage(named: sideMenu.imageName)
        
        self.stackViewButtons.isHidden = sideMenu.isHidden
        if sideMenu.isHidden{
            self.imgExpand.image = UIImage(systemName: "chevron.right")
        }else{
            self.imgExpand.image = UIImage(systemName: "chevron.down")
        }
        
        
        if Global.shared.loginUser?.roleName == "Coach"{
            self.viewAllCoaches.hide()
            self.viewConnectCoach.hide()
        }else{
            if (Global.shared.loginUser!.isGuest) {
                self.viewConnectCoach.hide()
            }
            self.viewAllStrikers.hide()
            self.viewInviteStriker.hide()
            self.viewConnectStriker.hide()
            
        }
    }
    
    
    @IBAction func btnAllStrikersClicked(_ sender: Any) {
        if let del = delegate{
            del.allStrikersClicked()
        }
    }
    
    @IBAction func btnConnectStrikerClicked(_ sender: Any) {
        if let del = delegate{
            del.connectStrikerClicked()
        }
    }
    
    
    @IBAction func btnInviteStrikerClicked(_ sender: Any) {
        if let del = delegate{
            del.inviteStrikerClicked()
        }
    }
    
    
    @IBAction func btnAllCoachesClicked(_ sender: Any) {
        if let del = delegate{
            del.allCoachesClicked()
        }
    }
    
    
    
    @IBAction func btnConnectCoachClicked(_ sender: Any) {
        if let del = delegate{
            del.connectCoachClicked()
        }
    }
    
}
