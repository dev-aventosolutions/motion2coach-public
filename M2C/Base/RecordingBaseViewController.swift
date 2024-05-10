//
//  RecordingOverlayReportViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/12/2022.
//

import UIKit
import AVKit
protocol updateReportProtocol : AnyObject{
    func updateReport(index: Int)
    func allFramesExtracted()
}

class RecordingBaseViewController: BaseVC {
    
    // MARK: Parent Outlets
    weak var reportDelegate: updateReportProtocol?
    weak var sliderSeekVideoBase: UISlider!
    weak var btnPlayPauseBase: UIButton!
    var imgPlayPauseBase: UIImageView!
    weak var imgFramesBase: UIImageView!
    weak var viewIndicatorBase: UIActivityIndicatorView!
    weak var txtCurrentFramesBase: UILabel!
    weak var viewReportPButtonsBase: UIView?
    weak var viewReportStackViewSliderBase: UIStackView?
    weak var sliderVerticalForceBase: UISlider?
    
    
    // MARK: VARIABLES
    var strikerBase: Striker?
    var recordingDescBase: RecordingDescription?
    var currentVideoMode: VideoMode = .originalVideo
    var highlightPoints: HighlightPoints?
    var editedHighlightPoints: HighlightPoints?
    var capture: CaptureModel?
    var videoDownloadUrl: String?
    var videoOverlayUrl: String?
    var isOverlayFramesExtracted: Bool = false
    var isOriginalFramesExtracted: Bool = false
    var isOverlayDownloaded: Bool = false
    var isOriginalVideoDownloaded: Bool = false
    //    var player = AVPlayer()
    var isOverlayPlaying = false
    var isOriginalVideoPlaying = false
    var asset: AVAsset?
    var isFirstTimeRecorded: Bool = false
    var isEdgeGestureAssigned = false
    var frames = [UIImage]()
    var overlayFrameChangeTimer = Timer()
    var downloadTimer: Timer? = nil
    var videoData: Data?
    private var videoManager: VideoManager? = nil
    var processingView: ProcessingView?
    var getPointsRetryCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.asset = nil
        self.videoManager = nil
        self.frames.removeAll()
//        self.frames = [UIImage]()
        self.overlayFrameChangeTimer.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.videoManager = nil
        self.frames.removeAll()
//        self.frames = [UIImage]()
        self.overlayFrameChangeTimer.invalidate()
    }
    
    func downloadVideo(videoDownloadUrl: String, videoMode: VideoMode) {
        print(videoDownloadUrl)
        
        //                self.hideIndicator()
        //        self.showIndicator(withTitle: "Downloading Video")
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: "\(videoDownloadUrl)")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { [self] (tempLocalUrl, response, error) in
            
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                    if statusCode == 404 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            //                            self.hideIndicator()
                            self.downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: videoMode)
                        })
                        return
                    } else if statusCode == 200 {
                        //                        self.hideIndicator()
                        // When video is downloaded successfully
                        self.downloadTimer?.invalidate()
                        
                        if videoMode == .overlayVideo{
                            self.isOverlayDownloaded = true
                            //                            locallySaveVideo(url: tempLocalUrl, videoMode: .overlayVideo)
                            self.locallySaveAndPlayVideo(url: tempLocalUrl)
                        }else{
                            self.isOriginalVideoDownloaded = true
                            self.locallySaveAndPlayVideo(url: tempLocalUrl)
                        }
                        
                        if highlightPoints == nil{
                            self.getHighlightPoints()
                        }
                        
                        // Downloading both original and overlay videos initially.
                        //                        hideIndicator()
                        //                        if !isOverlayDownloaded{
                        //                            // For downloading overlay video
                        //                            self.getVideoDownloadLink(videoMode: .overlayVideo) { [self] videoDownloadUrl in
                        //                                showIndicator(withTitle: "Downloading Overlay Video")
                        //
                        //                                if videoMode == .originalVideo{
                        //
                        //                                    if !isOverlayDownloaded{
                        //                                        downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                        //                                        downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .overlayVideo)
                        //
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                    }
                }
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
    
    
    func locallySaveVideo(url: URL, videoMode: VideoMode){
        
        if let urlData = NSData(contentsOf: url) {
            print(url)
            
            var name: String = ""
            if let capture = capture{
                if capture.overlayUrl.isEmpty{
                    // If user comes directly from processing screen and he has to save a downloaded video
                    name = self.videoOverlayUrl?.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
                }else{
                    // If user comes from history screen and he has to save a downloaded video
                    name = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
                }
            }
            
            // Saving Video with respective names
            if videoMode == .originalVideo{
                DocumentDirectory.saveData(data: urlData as Data, name: name)
                isOriginalVideoDownloaded = true
            }else if videoMode == .overlayVideo{
                DocumentDirectory.saveData(data: urlData as Data, name: "\(name)-overlay")
                isOverlayDownloaded = true
            }
            
        }
    }
    
    func locallySaveAndPlayVideo(url: URL){
        
        if let urlData = NSData(contentsOf: url) {
            print(url)
            
            var name: String = ""
            if let capture = capture{
                if capture.overlayUrl.isEmpty{
                    // If user comes directly from processing screen and he has to save a downloaded video
                    name = self.videoOverlayUrl?.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
                }else{
                    // If user comes from history screen and he has to save a downloaded video
                    name = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
                }
            }
            
            
            // Saving Video with respective names
            if currentVideoMode == .originalVideo{
                DocumentDirectory.saveData(data: urlData as Data, name: name)
                isOriginalVideoDownloaded = true
            }else if currentVideoMode == .overlayVideo{
                DocumentDirectory.saveData(data: urlData as Data, name: "\(name)-overlay")
                isOverlayDownloaded = true
            }
            
            //            self.hideIndicator()
            //            self.showIndicator(withTitle: "Extracting Frames")
            
            // For original video
            if currentVideoMode == .originalVideo{
                setVideo(videoMode: .originalVideo)
                
            }
            // For overlay video
            else{
                setVideo(videoMode: .overlayVideo)
                
            }
            
        }
    }
    
    
    func getVideoDownloadLink(videoMode: VideoMode, _ callback: @escaping ((String) -> ())) {
        
        // If the video is not prsent in Documents Directory. Then download the video
        //        self.hideIndicator()
        //        self.showIndicator(withTitle: "Fetching Video Data")
        
        var params : [String: String] = ["url": ""]
        if videoMode == .originalVideo{
            params["url"] = capture?.videoUrl
        } else if videoMode == .overlayVideo{
            params["url"] = capture?.overlayUrl
        }
        
        ServiceManager.shared.getOverlayVideo(parameters: params, success: { [self] response in
            let data = response as? String
            if let videoDownloadUrl = data{
                
                //                self.hideIndicator()
                callback(videoDownloadUrl)
                
            }
        }, failure: { error in
            self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
        })
    }
    
    // MARK: FETCH FRAMES
    func fetchFrames(data: Data, highlightPoints: HighlightPoints){
        frames.removeAll()
        
        // GETTING FRAMES
        self.videoManager = VideoManager()
        self.videoManager?.getFrames(data: data, points: highlightPoints) { [self] fetchedFrames in
            
            self.frames = fetchedFrames
            
            if self.frames.isEmpty{
                self.showPopupAlert(title: "Error", message: "No frames found.", hideCross: true, btnOkTitle: "Return to Dashboard" , onOK: {
                    AppDelegate.app.moveToDashboard()
                })
            }
            
            self.viewReportPButtonsBase?.unhide()
            self.viewReportStackViewSliderBase?.unhide()
            
            if currentVideoMode == .overlayVideo{
                isOverlayFramesExtracted = true
                isOriginalFramesExtracted = false
            }else{
                isOverlayFramesExtracted = false
                isOriginalFramesExtracted = true
            }
            
            DispatchQueue.main.async {
                self.imgFramesBase.image = self.frames.first
                self.processingView?.isHidden = true
            }
            
            let showSwipeGif = userDefault.getValue(key: UDKey.showPreviewGif) as? Bool
            showSwipeGif == true ? print("") : self.loadAndShowGif(gifName: "swipeLeft")
            userDefault.saveValue(value: true as Any, key: UDKey.showPreviewGif)
            
            
            // Left swipe gesture
            let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
            leftEdgePanGesture.edges = UIRectEdge.right
            leftEdgePanGesture.addTarget(self, action: #selector(self.handleLeftEdge(_:)))
            //            DispatchQueue.main.async { [self] in
            DispatchQueue.main.async {
                self.view.addGestureRecognizer(leftEdgePanGesture)
            }
            if !frames.isEmpty {
                //                        removeIrrelevantFrames()
                DispatchQueue.main.async {
                    self.sliderSeekVideoBase.maximumValue = self.frames.count.toFloat()
                    self.viewIndicatorBase.stopAnimating()
                    self.btnPlayPauseBase.unhide()
                    self.imgPlayPauseBase.unhide()
                }
                
                if let del = self.reportDelegate {
                    del.allFramesExtracted()
                }
                self.downloadTimer?.invalidate()
                //                    self.hideIndicator()
                DispatchQueue.main.async {
                    if self.currentVideoMode == .originalVideo{
                        self.imgFramesBase.image = self.frames.first?.rotate(radians: .pi/2)
                    }else{
                        self.imgFramesBase.image = self.frames.first
                    }
                }
            }
            //            }
            
            self.videoManager = nil
        }
    }
    
    @objc func handleLeftEdge(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
        
        //Check if gesture ended
        if (gesture.state == UIGestureRecognizer.State.ended) {
            
            DispatchQueue.main.async { [self] in
                let vc = RecordingReportViewController.initFrom(storyboard: .recording)
                if self.capture?.orientation == "" {
                    self.capture?.orientation = Global.shared.selectedOrientation?.name ?? ""
                }
                self.downloadTimer?.invalidate()
                overlayFrameChangeTimer.invalidate()
                
                frames.removeAll()
                self.frames = [UIImage()]
                vc.currentVideoMode = self.currentVideoMode
                vc.capture = capture
                //            vc.asset = self.asset
                vc.videoOverlayUrl = self.videoOverlayUrl
                vc.highlightPoints = highlightPoints
                vc.isOverlayDownloaded = self.isOverlayDownloaded
                vc.isOriginalVideoDownloaded = self.isOriginalVideoDownloaded
                
                vc.striker = strikerBase
                
                self.pushViewController(vc: vc)
            }
            
        }
    }
    
    
    @objc func downloadTimeout() {
        self.showPopupAlert(title: "", message: "Downloading is taking much longer than usual. You want to go back?", btnOkTitle: "Yes", btnCancelTitle: "Cancel", onOK: {
            self.downloadTimer?.invalidate()
            // On ok
            if self.isFirstTimeRecorded{
                self.popBackToOrientationScreen()
            }else{
                self.popViewController()
                self.dismiss(animated: true)
            }
        })
    }
    
    // MARK: FETCH POINTS AND FRAMES
    func fetchPointsAndFrames(data: Data){
        
        if let highlightPoints = self.highlightPoints{
            
            // If we have highlight points already
            self.fetchFrames(data: data, highlightPoints: highlightPoints)
            
        } else{
            
            getHighlightPoints()
            
        }
    }
    
    // MARK: SET VIDEO
    func setVideo(videoMode: VideoMode) {
        
        if let capture = capture{
            
            // For directly playing overlay video from first time recording.
            if let videoDownloadUrl = videoDownloadUrl{
                
                var extention: String = ""
                if videoMode == .overlayVideo{
                    extention = "-overlay"
                }
                
                // For checking if the video is in Documents Directory
                if let videoData = DocumentDirectory.getData(using: capture.videoName + extention).0 {
                    print("Video Fetched from document directory")
                    self.videoData = videoData
                    
                    // This check is temporary for playing local original video
                    if currentVideoMode == .originalVideo{
                        isOriginalVideoDownloaded = true
                        // GETTING FRAMES
                        self.fetchPointsAndFrames(data: videoData)
                        
                    }else{
                        isOverlayDownloaded = true
                        //                                                self.showIndicator(withTitle: "Extracting Overlay Frames")
                        // GETTING FRAMES
                        //                        self.fetchPointsAndFrames(data: videoData)
                        self.fetchPointsAndFrames(data: videoData)
                    }
                    
                    // Temporary
                    // When the user will switch segment after coming to Overlay Screen directly after
                    //                    if !isOverlayDownloaded{
                    //                        downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                    //
                    //                        downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .overlayVideo)
                    //
                    //                    }
                    
                }else{
                    // When the user will switch segment after coming to Overlay Screen directly after
                    if !isOverlayDownloaded{
                        self.downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                        
                        downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .overlayVideo)
                        
                        
                    }
                }
                
            } else{
                
                // To play video from history
                var extention: String = ""
                if videoMode == .overlayVideo{
                    extention = "-overlay"
                }
                
                let videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
                
                // For checking if the video is in Documents Directory
                if let videoData = DocumentDirectory.getData(using: videoId + extention).0 {
                    print("Video Fetched from document directory")
                    self.videoData = videoData
                    //                    self.fetchPointsAndFrames(data: videoData)
                    self.fetchPointsAndFrames(data: videoData)
                    
                } else{
                    
                    // If the video is not prsent in Documents Directory. Then download the video
                    //                    self.hideIndicator()
                    //                    self.showIndicator(withTitle: "Fetching Video Data")
                    
                    //                    var params : [String: String] = ["url": ""]
                    //                    if videoMode == .originalVideo{
                    //                        params["url"] = capture.videoUrl
                    //                    } else if videoMode == .overlayVideo{
                    //                        params["url"] = capture.overlayUrl
                    //                    }
                    
                    self.getVideoDownloadLink(videoMode: currentVideoMode) { [self] videoDownloadUrl in
                        
                        if videoMode == .originalVideo{
                            
                            if !isOriginalVideoDownloaded{
                                self.downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                                downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .originalVideo)
                            }
                            
                        } else if videoMode == .overlayVideo{
                            
                            if !isOverlayDownloaded{
                                self.downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                                downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .overlayVideo)
                            }
                        }
                    }
                    
                    //                    ServiceManager.shared.getOverlayVideo(parameters: params, success: { [self] response in
                    //                        let data = response as? String
                    //                        if let videoDownloadUrl = data{
                    //
                    //                            self.hideIndicator()
                    //                            if videoMode == .originalVideo{
                    //
                    //                                if !isOriginalVideoDownloaded{
                    //                                    self.downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                    //                                    downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .originalVideo)
                    //                                }
                    //
                    //                            } else if videoMode == .overlayVideo{
                    //
                    //                                if !isOverlayDownloaded{
                    //                                    self.downloadTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(downloadTimeout), userInfo: nil, repeats: true)
                    //                                    downloadVideo(videoDownloadUrl: videoDownloadUrl, videoMode: .overlayVideo)
                    //                                }
                    //                            }
                    //
                    //
                    //                        }
                    //                    }, failure: { error in
                    //                        self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
                    //                    })
                }
                
            }
        } else {
            self.showPopupAlert(title: "Error", message: "No capture found", btnOkTitle: "Ok")
        }
    }
    
    // MARK: GET HIGHLIGHT POINTS
    func getHighlightPoints(){
        
        // If striker will be received it means that a coach is trying to open a strikers video. If not then a user is trying to open his own videos
        var userId: String = ""
        var fileId: String = ""
        
        var videoId: String = ""
        // For getting highlight points from first time recording directly.
        if let overlayVideoUrl = videoOverlayUrl{
            videoId = overlayVideoUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
        }else{
            // For getting highlight points from history.
            videoId = capture?.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
        }
        
        strikerBase = Global.shared.selectedStriker
        if let striker = strikerBase {
            userId = striker.userId
            fileId = "\(striker.useremail.lowercased())/\(videoId).json"
        } else{
            userId = Global.shared.loginUser?.userId ?? ""
            fileId = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
        }
        
        let params = ["loggedUserId" : userId, "fileId": fileId]
        
        //        self.showIndicator(withTitle: "Fetching Highlight Points")
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.getHighlightPositions, params: params, method: .post, type: "highlight_points", loading: false, showErrorPrompt: false, headerType: .headerWithAuth)
    }
    
    @objc func frameChangeTimeAction(){
        
        sliderSeekVideoBase.maximumValue = Float(frames.count)
        let Range =  sliderSeekVideoBase.maximumValue - sliderSeekVideoBase.minimumValue;
        let Increment = Range/100;
        let newval = sliderSeekVideoBase.value + Increment
        if(Increment <= sliderSeekVideoBase.maximumValue) {
            
            print("The value of the slider is now \(sliderSeekVideoBase.value)")
            //            self.txtCurrentFramesBase.text = "Frames \(sliderSeekVideoBase.value.toInt())/\(frames.count)"
            self.sliderVerticalForceBase?.value  = self.recordingDescBase?.verticalForce[sliderSeekVideoBase.value.toInt()].toFloat() ?? 0.0
            
            if (sliderSeekVideoBase.value.toInt()) < (self.frames.count - 1){
                
                sliderSeekVideoBase.setValue(newval, animated: true)
                if sliderSeekVideoBase.value.toInt() > 0{
                    
                    // Rotating image to 90deg on Original video
                    if currentVideoMode == .originalVideo{
                        imgFramesBase.image = frames[sliderSeekVideoBase.value.toInt() - 1].rotate(radians: .pi/2)
                    }else{
                        imgFramesBase.image = frames[sliderSeekVideoBase.value.toInt() - 1]
                    }
                    
                }else{
                    // Rotating image to 90deg on Original video
                    if currentVideoMode == .originalVideo{
                        imgFramesBase.image = frames.first?.rotate(radians: .pi/2)
                    }else{
                        imgFramesBase.image = frames.first
                    }
                }
                
            } else{
                isOverlayPlaying = !isOverlayPlaying
                if isOverlayPlaying {
                    imgPlayPauseBase.image = UIImage(systemName: "pause.fill")
                } else {
                    overlayFrameChangeTimer.invalidate()
                    sliderSeekVideoBase.setValue(0, animated: false)
                    imgPlayPauseBase.image = UIImage(systemName: "play.fill")
                    
                    // Rotating image to 90deg on Original video
                    if currentVideoMode == .originalVideo{
                        imgFramesBase.image = frames.first?.rotate(radians: .pi/2)
                    }else{
                        imgFramesBase.image = frames.first
                    }
                }
            }
            //            sliderValue = Int(sliderSeekVideoBase.value)
            if let del = self.reportDelegate {
                del.updateReport(index: Int(ceil(sliderSeekVideoBase.value)))
            }
        } else if (Increment >= sliderSeekVideoBase.minimumValue) {
            sliderSeekVideoBase.setValue(newval, animated: true)
        }
    }
}


// MARK: SERVER RESPONSE
extension RecordingBaseViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        //        self.hideIndicator()
        
        if val == "highlight_points" {
            // To get highlight points
            self.highlightPoints = HighlightPoints(json: json)
            self.editedHighlightPoints = self.highlightPoints
            self.getPointsRetryCounter = 0
            
            //            self.editedHighlightPoints = HighlightPoints(json: json)
            
            if let videoData = self.videoData, let points = highlightPoints{
                self.fetchFrames(data: videoData, highlightPoints: points)
            }
        } else if val == "update_postions"{
            // To get upadted highlight points
            print(json)
            self.highlightPoints = HighlightPoints(json: json["positions"])
            
        }
    }
    
    func onFailure(json: JSON?, val: String) {
        
        //        self.hideIndicator()
        
        if val == "highlight_points" {
            print("Unable to fetch highlight points")
            
            self.getPointsRetryCounter+=1
            
            if getPointsRetryCounter > 5{
                showPopupAlert(title: "Error", message: "Highlight points may take longer than expected", hideCross: true, btnOkTitle: "Move to Home", onOK: {
                    AppDelegate.app.moveToDashboard()
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
                    self.getHighlightPoints()
                })
            }
        }
    }
}
