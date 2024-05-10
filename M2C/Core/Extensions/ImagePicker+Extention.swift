//
//  ImagePickerExtention.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit
import AVFoundation
import Photos

public protocol ImagePickerDelegate: AnyObject {
    func imageDidSelect(image: UIImage?,imageUrl:URL?,imageExtension:String,imageName:String)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera && !(self.checkCameraAccess())
            {
                
            }
            else if type == .photoLibrary && !(self.checkPhotoLibraryPermission())
            {
                
            }
            else
            {
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }
    
    public func checkCameraAccess() -> Bool{
        var isProceed = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            self.presentCameraSettings(message: "Camera access is denied")
            isProceed = false
        case .restricted:
            print("Restricted, device owner must approve")
            isProceed = false
        case .authorized:
            print("Authorized, proceed")
            isProceed = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    isProceed = true
                } else {
                    print("Permission denied")
                    isProceed = false
                }
            }
        @unknown default:
            fatalError()
        }
        return isProceed
    }
    
    func checkPhotoLibraryPermission() -> Bool{
        var isProceed = false
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                isProceed = true
                break
            //handle authorized status
            case .denied, .restricted :
                isProceed = false
                self.presentCameraSettings(message: "Photo library access is denied")
                break
            //handle denied status
            case .notDetermined:
                // ask for permissions
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        isProceed = true
                        break
                    // as above
                    case .denied, .restricted:
                        isProceed = false
                        self.presentCameraSettings(message: "Photo library access is denied")
                        break
                    // as above
                    case .notDetermined:
                        isProceed = false
                        break
                    // won't happen but still
                    case .limited:
                        isProceed = true
                        break
                    @unknown default:
                        fatalError()
                    }
                }
            case .limited:
                isProceed = true
                break
            @unknown default:
                fatalError()
            }
        
        return isProceed
        }
    

    public func presentCameraSettings(message:String) {
        let alertController = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        self.presentationController?.present(alertController, animated: true)
    }
    
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Camera") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let alertPopoverPresentationController : UIPopoverPresentationController  = alertController.popoverPresentationController!;
            alertPopoverPresentationController.sourceRect = sourceView.bounds;
            alertPopoverPresentationController.sourceView = sourceView;
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?,imageName:String,imageExtention:String,imageUrl:URL?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.imageDidSelect(image: image,imageUrl:imageUrl,imageExtension:imageExtention,imageName:imageName)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, imageName: "", imageExtention: "", imageUrl: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if  let image = info[.editedImage] as? UIImage {
            
            let imgName = "msg-\(NSDate().timeIntervalSince1970)"
            let success = FileUtilities.sharedUtilites.saveImageFromData(data: image.jpegData(compressionQuality: 0.5)!, fileName: imgName)
            if success{
                
                guard let imgUrl:URL = FileUtilities.sharedUtilites.getImageURL(name: imgName) else{
                    return
                }
                //                self.fileUrl = imgUrl
                let fileURL = String(describing: imgUrl)
                let fullNameArr = fileURL.split{$0 == "/"}.map(String.init)
                print("File Name \(fullNameArr.last!)")
                let fileName = fullNameArr.last!
                let fileExtent = fileURL.split{$0 == "."}.map(String.init)
                let fileExtention = fileExtent.last
                let fileUrl = imgUrl
                self.pickerController(picker, didSelect: image, imageName: fileName, imageExtention: fileExtention ?? ".png", imageUrl: fileUrl)
            }
        }
        
        if  let image = info[.originalImage] as? UIImage {
            
            let imgName = "msg-\(NSDate().timeIntervalSince1970)"
            let success = FileUtilities.sharedUtilites.saveImageFromData(data: image.jpegData(compressionQuality: 0.5)!, fileName: imgName)
            if success{
                
                guard let imgUrl:URL = FileUtilities.sharedUtilites.getImageURL(name: imgName) else{
                    return
                }
                //                self.fileUrl = imgUrl
                let fileURL = String(describing: imgUrl)
                let fullNameArr = fileURL.split{$0 == "/"}.map(String.init)
                print("File Name \(fullNameArr.last!)")
                let fileName = fullNameArr.last!
                let fileExtent = fileURL.split{$0 == "."}.map(String.init)
                let fileExtention = fileExtent.last
                let fileUrl = imgUrl
                self.pickerController(picker, didSelect: image, imageName: fileName, imageExtention: fileExtention ?? ".png", imageUrl: fileUrl)
            }
            }
        }
        
        
    
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
