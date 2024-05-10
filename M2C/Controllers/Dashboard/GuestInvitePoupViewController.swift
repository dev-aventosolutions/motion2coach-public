//
//  GuestInvitePoupViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/01/2023.
//

import UIKit

class GuestInvitePoupViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var btnGuestInvite: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    //MARK: VARIABLES
    var alertTitle: String = ""
    var alertMessage: String = ""
    var btnOkTitle: String = ""
    var onInviteGuest: (() -> Void)?
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.backgroundColor = UIColor.white
        showAnimate()
        
//        btnGuestInvite.setTitle(btnOkTitle, for: .normal)
//        btnCancel.setTitle(btnCancelTitle, for: .normal)
        
    }
    
    //MARK: ACTIONS
    @IBAction func btnGuestInviteClicked(_ sender: Any) {
        removeAnimate()
        onInviteGuest?()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        removeAnimate()
    }
}
