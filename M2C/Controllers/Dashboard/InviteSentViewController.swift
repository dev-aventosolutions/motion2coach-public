//
//  InviteSentViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 20/01/2023.
//

import UIKit

class InviteSentViewController: BaseVC {

    //MARK: OUTLETS
    
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: ACTIONS
    @IBAction func btnDoneClicked(_ sender: Any) {
        AppDelegate.app.moveToDashboard()
    }
    
}
