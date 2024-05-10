//
//  RecordingFaceOnVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import UIKit

class RecordingFaceOnVC: BaseVC {
    
    //------------------------------------
    // MARK: IBOutlets
    //------------------------------------
    
    @IBOutlet weak var viewForCamera: UIView!
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    var videoController: UIImagePickerController = UIImagePickerController()
    
    //------------------------------------
    // MARK: Overriden Functions
    //------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPictureCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.viewForCamera.willRemoveSubview(self.videoController.view)
    }
    
    
    func setupPictureCamera(){
        // Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoController.sourceType = .camera
            //change it to back only
            self.videoController.cameraCaptureMode = .photo
            videoController.cameraDevice = .rear
            videoController.delegate = self
            videoController.showsCameraControls = false
            let screenSize: CGSize = videoController.view.frame.size
            let ratio: CGFloat = 4.0 / 3.0
            let cameraHeight: CGFloat = screenSize.width * ratio - 50
            let scale: CGFloat = (screenSize.height + 80) / cameraHeight
            videoController.cameraViewTransform = videoController.cameraViewTransform.scaledBy(x: scale, y: scale)
            DispatchQueue.main.async
            {
                self.viewForCamera.addSubview(self.videoController.view)
                self.videoController.view.frame = self.viewForCamera.bounds
                self.videoController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.videoController.view.center = self.viewForCamera.center
                self.viewForCamera.sendSubviewToBack(self.videoController.view)
            }
        }
        else {
            self.noCamera()
            print("Camera is not available")
        }
    }
    
    func noCamera() {
        print("This device has no camera")
    }
    
    @IBAction func actionCapture(_ sender: Any) {
        self.videoController.takePicture()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
}


//------------------------------------
// MARK: Extensions
//------------------------------------
//------------------------------------
// MARK: UIImagePickerControllerDelegate
//------------------------------------
extension RecordingFaceOnVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imageDidSelect(image: UIImage?, imageUrl: URL?, imageExtension: String, imageName: String) {
        print("none")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        Global.shared.livePhoto = image
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingFaceOnImageVCID)
    }
}
