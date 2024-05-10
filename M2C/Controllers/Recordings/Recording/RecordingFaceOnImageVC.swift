//
//  RecordingFaceOnImageVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import UIKit

class RecordingFaceOnImageVC: BaseVC {
    
    @IBOutlet weak var imgCaptured: UIImageView!
    var takenPhoto: UIImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCaptured.image = Global.shared.livePhoto
        // Do any additional setup after loading the view.
    }
    @IBAction func actionCapture(_ sender: Any) {
        self.navigateBack()
    }
    @IBAction func actionRecordVideo(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingVCID)
    }
    @IBAction func actionBack(_ sender: Any) {
        self.popBackToDashboardOptions()
    }

}
