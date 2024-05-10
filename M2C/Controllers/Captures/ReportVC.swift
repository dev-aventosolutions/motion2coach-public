//
//  ReportVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 14/06/2022.
//

import UIKit

class ReportVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionHome(_ sender: Any) {
        self.popBackToDashboardOptions()
    }
    

}
