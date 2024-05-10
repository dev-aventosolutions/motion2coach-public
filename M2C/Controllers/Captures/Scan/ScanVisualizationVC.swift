//
//  scanVisualization.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 26/06/2022.
//

import UIKit

class ScanVisualizationVC: BaseVC {

    @IBOutlet weak var imgScan: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgScan.image = Global.shared.livePhoto
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionCapture(_ sender: Any) {
        self.popBackToDashboardOptions()
    }

}
