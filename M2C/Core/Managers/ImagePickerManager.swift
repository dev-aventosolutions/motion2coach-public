//
//  ImagePickerManager.swift
//  Afrosdate
//
//  Created by Abdul Samad butt on 20/10/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;

    override init(){
        super.init()
    }

    // Pick Image from Camera and gallery menu
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = false
            
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .actionSheet)
            
//            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.present(alertWarning, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.viewController!.present(picker, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Pick image from gallery
    func pickImageFromGallery(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        self.viewController!.present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
    //MARK: Pick image from gallery
    func pickImageFromCamera(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;


        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        
        viewController.present(picker, animated: true, completion: nil)
    }
    
    

    //MARK: Pick image from Camera
    func pickImageFromCamera(vc: UIViewController) {
        picker.sourceType = .camera
        picker.allowsEditing = false
        vc.present(picker, animated: true, completion: nil)
    }
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let compressedImage = image.compressImage(compressionRate: 0.1)
        pickImageCallback?(compressedImage.resizeWithWidth(width: 700)!)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
