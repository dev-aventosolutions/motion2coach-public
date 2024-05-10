//
//  LiveSecondVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import UIKit

class ScanSecondVC: BaseVC {
    
    @IBOutlet weak var imgCaptured: UIImageView!
    
    var takenPhoto: UIImage = UIImage()
    var signedUrl: String = ""
    var publicUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCaptured.image = Global.shared.livePhoto
        
    }
    
    @IBAction func actionCapture(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionVisualize(_ sender: Any) {
        //        self.navigateForward(storyBoard: SBCaptures, viewController: scanVisualizationVCID)
        
        let vc = ProcessingViewController.initFrom(storyboard: .captures)
        vc.isPictureUploading = true
        vc.takenPhoto = takenPhoto
        pushViewController(vc: vc)
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.popBackToDashboardOptions()
    }
}

extension ScanSecondVC: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        if val == "uploadMedia"{
            
            self.publicUrl = json["publicUrl"].stringValue
            self.signedUrl = json["signedUrl"].stringValue
            
            // Step 2 of Image Upload
            if let imageData = takenPhoto.pngRepresentationData{
                ServiceManager.shared.multipartRequestForImage(vc: self, url: signedUrl, imageBinary: imageData, loading: true) { response in
                    print(response)
                    
                    // Step 3 of Image Upload
                    let vc = ProcessingViewController.initFrom(storyboard: .captures)
                    vc.isPictureUploading = true
                    self.pushViewController(vc: vc)
                    
                } failure: { error in
                    print(error)
                }
            }
            
        }
        
    }
    
}
