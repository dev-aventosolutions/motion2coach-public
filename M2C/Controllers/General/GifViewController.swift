//
//  GifViewController.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 07.11.22.
//

import UIKit

class GifViewController: BaseVC {

    @IBOutlet weak var gifImage: UIImageView!
    var gifName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImage.loadGif(name: gifName)
        // Do any additional setup after loading the view.
    }
   

}
