//
//  SuccessViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 16/11/2022.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var txtMessage: UILabel!
    
    var alertMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.backgroundColor = UIColor.white
        
        txtMessage.text = alertMessage
        showAnimate()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.removeAnimate()
        AppDelegate.app.moveToLogin()
    }
}
