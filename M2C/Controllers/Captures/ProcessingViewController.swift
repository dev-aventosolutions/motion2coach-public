//
//  ProcessingViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 02/08/2022.
//

import UIKit
import Starscream

class ProcessingViewController: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var viewLoader: UIImageView!
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var viewBack: UIView!
    
    //MARK: VARIABLES
    var takenPhoto: UIImage = UIImage()
    var signedUrl: String = ""
    var publicUrl: String = ""
    var isVideoUploading: Bool = false
    var isPictureUploading: Bool = false
    var videoLocalUrl: URL?
    var videoBinaryData: Data?
    var capture: CaptureModel?
    var videoDownloadUrl: String?
    var videoOverlayUrl: String?
    var url: String?
    var socket: WebSocket?
    var isConnected = false
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepIndicatorView.currentStep = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadStep1), name: .videoUploadStep1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadStep2), name: .videoUploadStep2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadStep3), name: .videoUploadStep3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadStep4), name: .videoUploadStep4, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadErrorStep1), name: .videoUploadErrorStep1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadErrorStep2), name: .videoUploadErrorStep2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadErrorStep3), name: .videoUploadErrorStep3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoUploadErrorStep4), name: .videoUploadErrorStep3, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.serverStatus), name: .serverStatus, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver("videoUploadStep1")
        NotificationCenter.default.removeObserver("videoUploadStep2")
        NotificationCenter.default.removeObserver("videoUploadStep3")
        NotificationCenter.default.removeObserver("videoUploadStep4")
        
        NotificationCenter.default.removeObserver("videoUploadErrorStep1")
        NotificationCenter.default.removeObserver("videoUploadErrorStep2")
        NotificationCenter.default.removeObserver("videoUploadErrorStep3")
        NotificationCenter.default.removeObserver("videoUploadErrorStep4")
        
        NotificationCenter.default.removeObserver("serverStatus")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // For picture uploading
        if isPictureUploading{
            
//            stepIndicatorView.currentStep = 1
            // Step 1 of Image Upload
            UploadMediaRequest.shared.fileMimeType = takenPhoto.pngRepresentationData?.mimeType ?? ""
            UploadMediaRequest.shared.fileName = "m2c_\(Date.currentTimeStamp)" + ".png"
            
            serverRequest.delegate = self
            serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.uploadMedia, params: UploadMediaRequest.shared.returnUploadMediaParams(), method: .post, type: "uploadMedia", loading: false, headerType: .headerWithoutAuth)
        }
        // For video uploading
        else{
            if let url = videoLocalUrl, let bytes = videoBinaryData{
                CoreDataManager.shared.createCapture(url: url, binary: bytes, dateAdded: Date())
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewLoader.rotateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.socket?.disconnect()
    }
    
    //MARK: SOCKETS
    func connectAndRequestSocket() {
        var request = URLRequest(url: URL(string: ServiceUrls.socketUrl)!)
        request.httpShouldUsePipelining = true
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func createAction() {

        if let url = url {
//            print(url)
            let strChannel = "{ \"action\": \"status\",\"file_id\": \"\(url)\" }"
//            print(strChannel)
            self.socket?.write(string: strChannel)
        }
    }
    
    func updateCurrentStatus(status: String) {
        
        if let dict = status.toDictionary(){
            let status = dict["status"] as! String
            
            if status == "uploaded"{
                stepIndicatorView.currentStep = 1
                self.viewBack.isHidden = false
                
            } else if status == "processing"{
                stepIndicatorView.currentStep = 2
                
            }else if status == "done"{
                
                self.socket?.disconnect()
                stepIndicatorView.currentStep = 3
                
                if let user = Global.shared.loginUser{
                    
                    // Guest cannot view the overlay.
                    // In the case of guest the user will be redirected to Dashboard Page
                    if user.isGuest{
                        
                        self.showPopupAlert(title: "Alert!", message: "Subscribe to view report.", btnOkTitle: "Ok", onOK: {
                            AppDelegate.app.moveToDashboard()
                        })
                        
                    }else{
                        
                        let vc = RecordingOverlayPreviewViewController.initFrom(storyboard: .recording)
                        vc.isFirstTimeRecorded = true
                        if var capture = self.capture{
                            capture.overlayUrl = videoOverlayUrl ?? ""
                            vc.capture = capture
                            vc.videoDownloadUrl = videoDownloadUrl
                            vc.videoOverlayUrl = videoOverlayUrl
                        }
                        self.pushViewController(vc: vc)
                    }
                }
                
            }else if status == "error"{
                self.socket?.disconnect()
                self.showPopupAlert(title: "Error", message: "You have uploaded the video with wrong metadata. Please record again", btnOkTitle: "Ok", onOK: {
                    AppDelegate.app.moveToDashboard()
                })
            }
        }
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        if isVideoUploading{
            popBackToOrientationScreen()
        } else{
            popViewController()
        }
    }
    
    //MARK: HELPERS
    @objc func videoUploadStep1(notification: Notification){
        
        if let userInfo = notification.userInfo{
            self.capture = userInfo["capture"] as? CaptureModel
        }
        stepIndicatorView.currentStep = 1
        
    }
    
    @objc func videoUploadStep2(){
        print("Video Upload Step 2")
    }
    
    @objc func videoUploadStep3(){
        print("Video Upload Step 3")
    }
    
    @objc func videoUploadStep4(notification: Notification){
        
        print("Video Upload Step 4")
        
        if let userInfo = notification.userInfo{
            videoDownloadUrl = userInfo["videoDownloadUrl"] as? String
            videoOverlayUrl = userInfo["videoOverlayUrl"] as? String
            url = userInfo["url"] as? String
        }
        
        self.connectAndRequestSocket()
        
    }
    
    // Error CallBacks
    @objc func videoUploadErrorStep1(notification: Notification){
        print ("Error on Step 1")
        self.showPopupAlert(title: "Server Error!", message: "The operation could not be completed. Please try again", btnOkTitle: "Return to recording", onOK: {
            self.popViewController()
        })
    }
    
    @objc func videoUploadErrorStep2(){
        print ("Error on Step 2")
        self.showPopupAlert(title: "Server Error!", message: "The operation could not be completed. Please try again", btnOkTitle: "Return to recording", onOK: {
            self.popViewController()
        })
    }
    
    @objc func videoUploadErrorStep3(){
        print ("Error on Step 3")
        self.showPopupAlert(title: "Server Error!", message: "The operation could not be completed. Please try again", btnOkTitle: "Return to recording", onOK: {
            self.popViewController()
        })
    }
    
    @objc func videoUploadErrorStep4(notification: Notification){
        print ("Error on Step 4")
        self.showPopupAlert(title: "Server Error!", message: "The operation could not be completed. Please try again", btnOkTitle: "Return to recording", onOK: {
            self.popViewController()
        })
    }
    
    @objc func serverStatus(notification: Notification){
        
        print("Server Status Check")
        
        if let userInfo = notification.userInfo{
            let status = userInfo["trackingStatus"] as? String
            
            // if status is busy
            if status == "busy"{
                self.showPopupAlert(title: "Alert!", message: "Server is processing the video. This may take longer than usual.", hideCross: true, btnOkTitle: "Return to recording", onOK: {
                    self.popViewController()
                })
            } else {
                self.showPopupAlert(title: "Alert!", message: "Server is busy. This may take longer than usual.", hideCross: true, btnOkTitle: "Return to recording", onOK: {
                    self.popViewController()
                })
            }
        }
    }
}

//MARK: SERVER RESPONSE
extension ProcessingViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        if val == "uploadMedia"{
            
            self.publicUrl = json["publicUrl"].stringValue
            self.signedUrl = json["signedUrl"].stringValue
//            stepIndicatorView.currentStep = 2
            // Step 2 of Image Upload
            if let imageData = takenPhoto.pngRepresentationData{
                ServiceManager.shared.multipartRequestForImage(vc: self, url: signedUrl, imageBinary: imageData, loading: false) { response in
                    print(response)
                    
//                    self.stepIndicatorView.currentStep = 3
                    // Step 3 of Image Upload
                    let params: [String : Any] = ["loggedUserId" : Global.shared.loginUser?.userId ?? 0,
                                                  "title" : "scan",
                                                  "scanUrl": self.publicUrl]
                    ServiceManager.shared.addScannedImage(parameters: params) { response in
                        print(response)
                        
                        let vc = ScanVisualizationVC.initFrom(storyboard: .captures)
                        self.pushViewController(vc: vc)
                    } failure: { error in
                        print(error)
                        
                    }
                    
                } failure: { error in
                    print(error)
                }
            }
            
        }
        
    }
    
}

extension ProcessingViewController: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        
        socket?.onEvent = { event in
            switch event {
                // handle events just like above...
            case .connected(let headers):
                self.isConnected = true
                self.createAction()
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                self.isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.createAction()
                    self.updateCurrentStatus(status: string)
                })
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected = false
            case .error(let error):
                self.isConnected = false
                print(error)
            }
        }
    }
    
}
