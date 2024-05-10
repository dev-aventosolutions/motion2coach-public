//
//  ActivateUserViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 04/11/2022.
//

import UIKit

class ActivateUserViewController: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var btnSendOtp: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var txtEmail: UILabel!
    
    // MARK: VARIABLES
    var onSendOtp: (() -> Void)?
    var email: String = ""
    
    // MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.backgroundColor = UIColor.white
        
        self.txtEmail.text = email
        showAnimate()
    }
    
    //MARK: ACTIONS
    @IBAction func btnSendOtpClicked(_ sender: Any) {
        removeAnimate()
        onSendOtp?()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        removeAnimate()
    }

}


