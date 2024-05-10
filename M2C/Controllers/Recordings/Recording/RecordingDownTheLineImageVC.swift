//
//  RecordingDownTheLineImageVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import UIKit

class RecordingDownTheLineImageVC: BaseVC {

    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var imgCaptured: UIImageView!
    var takenPhoto: UIImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.btnRepeat.imageView?.image?.size = CGSize(width: 20.0, height: 20.0)
//        self.btnRecord.imageView?.image?.size = CGSize(width: 25.0, height: 25.0)

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

