//
//  DashboardVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import UIKit

class DashboardVC: BaseVC {

 
    
    //------------------------------------
    // MARK: IBOutlets
    //------------------------------------
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLetsGetStarted: UILabel!
    @IBOutlet weak var lblRecordSwing: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var imgSwing: UIImageView!
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    
    
    //------------------------------------
    // MARK: Overriden Functions
    //------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received in DashboardVC")
    }
    //------------------------------------
    // MARK: IBActions
    //------------------------------------
    @IBAction func actionSideMenu(_ sender: Any) {
        self.showSideMenu()
    }
    
    @IBAction func actionRecord(_ sender: Any) {
      
    }
    
    @IBAction func actionHistory(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingHistoryVCID)
    }
    
    @IBAction func actionProfile(_ sender: Any) {
        self.navigateForward(storyBoard: SBDashboard, viewController: profileVCID)
    }
}
