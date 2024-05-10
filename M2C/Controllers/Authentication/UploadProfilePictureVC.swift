//
//  UploadProfilePictureVC.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/07/2022.
//

import UIKit
import Photos
import PhotosUI

class UploadProfilePictureVC: UIViewController {
    
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    
    var signedUrl: String = ""
    var publicUrl: String = ""
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        btnUpload.hide()
        imgUser.contentMode = .scaleAspectFill
    }
    
    @IBAction func btnTakePhotoClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnChooseFromGalleryClicked(_ sender: Any) {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 0
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        popViewController()
    }
    
    @IBAction func btnSkipClicked(_ sender: Any) {
        SignUpRequest.shared.picture = "https://m2c-media.s3.eu-central-1.amazonaws.com/m2c_user_avatar_01.jpg"
        signUpUser()
    }
    
    @IBAction func btnUploadClicked(_ sender: Any) {
        // Step 1 of Image Upload
        UploadMediaRequest.shared.fileMimeType = pickedImage!.pngRepresentationData?.mimeType ?? ""
        UploadMediaRequest.shared.fileName = SignUpRequest.shared.firstName + "uploaded" + ".png"
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.uploadMedia, params: UploadMediaRequest.shared.returnUploadMediaParams(), method: .post, type: "uploadMedia", loading: true, headerType: .headerWithoutAuth)
    }
    
    
    private func signUpUser(){
        if #available(iOS 15, *) {
            SignUpRequest.shared.registrationDate = Date.now.toDateString(format: DateFormats.DateFormatStandard2)
        } else {
            // Fallback on earlier versions
        }
        SignUpRequest.shared.deviceId = getUUID()
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.signUp, params: SignUpRequest.shared.returnSignupParams(), method: .post, type: "signup", loading: true, headerType: .headerWithoutAuth)
    }
    
    fileprivate func uploadMedia(){
        
    }
    
}

extension UploadProfilePictureVC: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    // Picking image form Gallery
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//        let size = CGSize(width: 100, height: 100)
//
//        PHImageManager.default().requestImage(for: results.first, targetSize: size, contentMode: .default, options: nil, resultHandler: { (image, info) in
//            imgUser.image = image
//            pickedImage = image
//            if pickedImage != nil{
//                btnUpload.show()
//            }
//        })
//    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.imgUser.image = image
                            self.pickedImage = image
                            if self.pickedImage != nil{
                                self.btnUpload.show()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Picking image from camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imgUser.contentMode = .scaleAspectFill
        imgUser.image = image
        pickedImage = image.resizeWithPercent(percentage: 0.15)
        if pickedImage != nil{
            btnUpload.show()
        }
    }
}

extension UploadProfilePictureVC: ServerResponse{
    func onSuccess(data: Data, val: String) {
        
    }
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "uploadMedia" {
            self.publicUrl = json["publicUrl"].stringValue
            self.signedUrl = json["signedUrl"].stringValue
            
            SignUpRequest.shared.picture = publicUrl
            
            // Step 2 of Image Upload
            if let imageData = pickedImage?.pngRepresentationData{
                ServiceManager.shared.multipartRequestForImage(vc: self, url: signedUrl, imageBinary: imageData, loading: true) { response in
                    print(response)
                    
                    // Step 3 of Image Upload
                    self.signUpUser()
                } failure: { error in
                    print(error)
                }
            }
            
            
        } else if val == "signup"{
            let signUpUser = SignUpUser(json: json)
            
            let vc = OtpVerificationVC.initFrom(storyboard: .auth)
            vc.signUpUser = signUpUser
            pushViewController(vc: vc)
        }
    }
}
