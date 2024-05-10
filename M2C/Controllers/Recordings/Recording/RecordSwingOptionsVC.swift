//
//  RecordSwingOptionsVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import UIKit

class RecordSwingOptionsVC: BaseVC {

    @IBOutlet weak var lblReminder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblReminder.attributedText = NSMutableAttributedString()
            .blueForeground("Reminder: ")
            .normal("Avoid swaying (too much lower body movement to the right) to maintain a stable lower body")
    }
     
    @IBAction func actionDownTheLine(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingDownTheLineVCID)
    }
    
    @IBAction func actionFaceFront(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingFaceOnVCID)
    }
    
}
