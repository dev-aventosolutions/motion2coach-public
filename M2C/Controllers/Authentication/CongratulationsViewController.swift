//
//  CongratulationsViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 09/11/2022.
//

import UIKit

class CongratulationsViewController: BaseVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func btnDashboardClicked(_ sender: Any) {
        AppDelegate.app.moveToDashboard()
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        AppDelegate.app.moveToLogin()
    }
}
