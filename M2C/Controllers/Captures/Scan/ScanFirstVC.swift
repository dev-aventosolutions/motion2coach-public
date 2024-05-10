//
//  LiveFirstVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 14/06/2022.
//

import UIKit
import Photos
import MobileCoreServices


class ScanFirstVC: BaseVC {
    
    //------------------------------------
    // MARK: IBOutlets
    //------------------------------------
    
    @IBOutlet weak var viewForCamera: UIView!
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    var videoController: UIImagePickerController = UIImagePickerController()
    var overlayView = UIView()
    
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
            //change it to back only
            videoController.sourceType = .camera
            videoController.cameraDevice = .rear
//            self.videoController.mediaTypes = [UTType.livePhoto.identifier as String]

            self.videoController.cameraCaptureMode = .photo
            videoController.delegate = self
            videoController.showsCameraControls = false
            videoController.allowsEditing = false
            let screenSize: CGSize = videoController.view.frame.size
            let ratio: CGFloat = 4.0 / 3.0
            let cameraHeight: CGFloat = screenSize.width * ratio - 50
            let scale: CGFloat = (screenSize.height + 80) / cameraHeight
            videoController.cameraViewTransform = videoController.cameraViewTransform.scaledBy(x: scale, y: scale)
            DispatchQueue.main.async
            {
                self.viewForCamera.addSubview(self.videoController.view)
                self.videoController.view.frame = self.view.frame
                self.videoController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.videoController.view.center = self.viewForCamera.center
                self.viewForCamera.sendSubviewToBack(self.videoController.view)
                
//                self.hideDefaultEditOverlay(view: self.view)
            }
            
//            self.setUpCameraOverLayView()
        }
        else {
            self.noCamera()
            print("Camera is not available")
        }
    }
    
    private func hideDefaultEditOverlay(view: UIView)
    {
        for subview in view.subviews
        {
            if let cropOverlay = NSClassFromString("CAMImagePickerCameraViewController")
            {
                if subview.isKind(of: cropOverlay) {
                    subview.isHidden = true
                    break
                }
                else {
                    hideDefaultEditOverlay(view: subview)
                }
            }
        }
    }
    
    func noCamera() {
        print("This device has no camera")
    }
    
//    func setUpCameraOverLayView(){
//        self.videoController.cameraOverlayView = self.overlayView
//        self.overlayView.frame = self.videoController.view.bounds
//        self.overlayView.center = self.videoController.view.center
//        self.addCrossButton()
//        self.addLabelView()
//        self.addDemoImage()
//
//    }
//
//    func addCrossButton(){
//        let btnCross = UIButton()
//        btnCross.setImage(UIImage.init(named: "cross"), for: .normal)
//        //add Constraints
//        self.overlayView.addSubview(btnCross)
//        btnCross.translatesAutoresizingMaskIntoConstraints = false
//            let topConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 70)
//
//        let trailingConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
//
//            let widthConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//            let heightConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//        NSLayoutConstraint.activate([topConstraint, trailingConstraint, widthConstraint, heightConstraint])
//        self.overlayView.bringSubviewToFront(btnCross)
//        btnCross.addTarget(self, action: #selector(self.actionBack(_:)), for: .touchUpInside)
//    }
//
//    func addLabelView(){
//
//        let view = UIView()
//        view.cornerRadius = 7.0
//        view.backgroundColor = .white
//        self.overlayView.addSubview(view)
//
//        //add Constraints
//
//        let label = UILabel()
//        label.text = "Kindly Stand Like This"
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont(name: "OpenSans-SemiBold", size: 16.0)
//        view.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        let trailing = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
//
//        let leading = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
//
//        let top = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
//
//        let bottom = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//            let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 70)
//        let horizontalConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//
//        let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
//
//        NSLayoutConstraint.activate([topConstraint, horizontalConstraint, heightConstraint,widthConstraint])
//
//        NSLayoutConstraint.activate([ top, leading, trailing, bottom])
//        view.bringSubviewToFront(label)
//        self.overlayView.bringSubviewToFront(view)
//    }
//
//    func addCaptureButton(){
//        let btnCross = UIButton()
//        btnCross.setImage(UIImage.init(named: "cross"), for: .normal)
//        //add Constraints
//        self.overlayView.addSubview(btnCross)
//        btnCross.translatesAutoresizingMaskIntoConstraints = false
//            let topConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 70)
//
//        let trailingConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
//
//            let widthConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//            let heightConstraint = NSLayoutConstraint(item: btnCross, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//        NSLayoutConstraint.activate([topConstraint, trailingConstraint, widthConstraint, heightConstraint])
//        self.overlayView.bringSubviewToFront(btnCross)
//        btnCross.addTarget(self, action: #selector(self.actionBack(_:)), for: .touchUpInside)
//    }
    
    func addDemoImage(){
        let img = UIImageView()
        img.image = UIImage(named: "LiveFirstStand")
        img.contentMode = .scaleAspectFill
        //add Constraints
        self.overlayView.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 190)
        
        let horizontalConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.9, constant: 1)
        
        let heightConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.overlayView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.6, constant: 1)
        NSLayoutConstraint.activate([topConstraint, horizontalConstraint, widthConstraint, heightConstraint])
        self.overlayView.bringSubviewToFront(img)
    }
    
    @IBAction func actionCapture(_ sender: Any) {
        self.videoController.takePicture()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    //------------------------------------
    @IBAction func actionCross(_ sender: UIButton) {
        self.videoController.dismiss(animated: true)
        self.popBackToDashboard()
    }
}


//------------------------------------
// MARK: Extensions
//------------------------------------
//------------------------------------
// MARK: UIImagePickerControllerDelegate
//------------------------------------
extension ScanFirstVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        let vc = ScanSecondVC.initFrom(storyboard: .captures)
        
        if let image = image.resizeWithPercent(percentage: 0.15){
            vc.takenPhoto = image
        }
        self.pushViewController(vc: vc)
        
//        self.navigateForward(storyBoard: SBCaptures, viewController: scanSecondVCID)
    }
}
