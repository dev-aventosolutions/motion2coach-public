//
//  RecordingReportViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 12/09/2022.
//

import UIKit
import Alamofire
import AVKit
import SDWebImage

class RecordingReportViewController: RecordingBaseViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var btnRecordVideo: UIButton!
    @IBOutlet weak var sliderSeekVideo: UISlider!
    @IBOutlet weak var imgFrames: UIImageView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var imgPlayPause: UIImageView!
    @IBOutlet weak var viewSeekSlider: UIView!
    @IBOutlet weak var collectionViewReport: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var viewVerticalForceSlider: UIView!
    @IBOutlet weak var viewP1: UIView!
    @IBOutlet weak var viewP2: UIView!
    @IBOutlet weak var viewP3: UIView!
    @IBOutlet weak var viewP4: UIView!
    @IBOutlet weak var viewP5: UIView!
    @IBOutlet weak var viewP6: UIView!
    @IBOutlet weak var viewP7: UIView!
    @IBOutlet weak var viewP8: UIView!
    @IBOutlet weak var viewP9: UIView!
    @IBOutlet weak var viewP10: UIView!
    @IBOutlet weak var imgP1: UIImageView!
    @IBOutlet weak var imgP2: UIImageView!
    @IBOutlet weak var imgP3: UIImageView!
    @IBOutlet weak var imgP4: UIImageView!
    @IBOutlet weak var imgP5: UIImageView!
    @IBOutlet weak var imgP6: UIImageView!
    @IBOutlet weak var imgP7: UIImageView!
    @IBOutlet weak var imgP8: UIImageView!
    @IBOutlet weak var imgP9: UIImageView!
    @IBOutlet weak var imgP10: UIImageView!
    @IBOutlet weak var txtMaxVerticalForce: UILabel!
    @IBOutlet weak var txtMinVerticalForce: UILabel!
    @IBOutlet weak var txt200VerticalForce: UILabel!
    @IBOutlet weak var txt100VerticalForce: UILabel!
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var viewPositions: UIView!
    @IBOutlet weak var stackViewSlider: UIStackView!
    @IBOutlet weak var btnFrameUp: UIButton!
    @IBOutlet weak var viewFrameUp: UIView!
    @IBOutlet weak var viewFrameDown: UIView!
    @IBOutlet weak var btnFrameDown: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var btnPoints: [UIButton]!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sliderVerticalForce: BorderedUISlider!{
        didSet{
            sliderVerticalForce.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        }
    }
    @IBOutlet var arrViewPositions: [UIView]!
    
    var striker: Striker?
    var player = AVPlayer()
    let playerController = AVPlayerViewController()
    var currentIndexPath: IndexPath = [0,0]
    var dataHighlights: [RecordingReport]?
    var collectionViewDataHighlights2: [RecordingReport]?
    var collectionViewDataDescription: [RecordingReport]?
    var recordingDesc: RecordingDescription?
    var highlights2: RecordingHighlights2?
    var arrSeekSliderData: [SeekSliderData] = [SeekSliderData]()
//    var currentVideoMode: VideoMode = .overlayVideo
//    private var frames: [UIImage] = [UIImage]()
//    var highlightPoints: HighlightPoints?
//    var isOverlayFramesExtracted: Bool = false
//    var isOriginalFramesExtracted: Bool = false
//    var isOverlayDownloaded: Bool = false
//    var isOriginalVideoDownloaded: Bool = false
//    var overlayFrameChangeTimer = Timer()
//    var downloadTimer: Timer? = nil
//    private var videoManager: VideoManager? = nil
//    var asset: AVAsset!
//    var capture: CaptureModel?
//    var isOverlayPlaying = false
//    var isOriginalVideoPlaying = false
//    var videoOverlayUrl: String?
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewReportPButtonsBase = self.viewPositions
        self.viewReportStackViewSliderBase = self.stackViewSlider
        self.sliderVerticalForceBase = self.sliderVerticalForce
//        self.txtMaxVerticalForce.text = "2000"
        self.sliderVerticalForce.maximumValue = 300
        self.sliderVerticalForce.minimumValue = 0
        self.sliderVerticalForce.setThumbImage(UIImage(), for: .normal)
        
        self.reportDelegate = self
        sliderSeekVideo.isUserInteractionEnabled = false
        //Temporary check
        currentVideoMode = .overlayVideo
        self.viewPositions.hide()
        self.stackViewSlider.hide()
        
        self.getHighlights()
        self.getDescription()
//        getHighlights2()
        if highlightPoints == nil{
            getHighlightPoints()
        }
        
//        self.viewVerticalForceSlider.hide()
//        if striker != nil {
//            self.btnRecordVideo.hide()
//        }
        
        
//        var labelArray: [UILabel] = []
//        labelArray.append(txtMinVerticalForce)
//        labelArray.append(txtMaxVerticalForce)
//        labelArray.append(txt100VerticalForce)
//        labelArray.append(txt200VerticalForce)
//        
//        for i in 0..<labelArray.count {
//            
//            view.addSubview(labelArray[i])
//            labelArray[i].translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                labelArray[i].topAnchor.constraint(equalTo: sliderVerticalForce.bottomAnchor, constant: 10),
//                labelArray[i].widthAnchor.constraint(equalTo: sliderVerticalForce.widthAnchor, multiplier: 0.25),
//                labelArray[i].centerXAnchor.constraint(equalTo: sliderVerticalForce.leadingAnchor, constant: CGFloat(i) * sliderVerticalForce.frame.width / 3 + sliderVerticalForce.frame.width / 6)
//            ])
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.frames.removeAll()
        self.frames = [UIImage()]
        SDImageCache.shared.clearMemory()
        self.overlayFrameChangeTimer.invalidate()
        downloadTimer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.frames.removeAll()
        self.frames = [UIImage()]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.processingView = ProcessingView.fromNib()
        self.view.addSubview(self.processingView!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.setupUI()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received in RecordingReportViewController")
    }
    
    func setupUI(){
        self.sliderSeekVideoBase = self.sliderSeekVideo
        self.btnPlayPauseBase = self.btnPlayPause
        self.imgPlayPauseBase = self.imgPlayPause
        self.imgFramesBase = self.imgFrames
        self.viewIndicatorBase = self.viewIndicator
        segmentControl.selectedSegmentIndex = currentVideoMode == .originalVideo ? 0 : 1
        viewSeekSlider.layer.shadowColor = UIColor.darkGray.cgColor
        viewSeekSlider.layer.shadowOpacity = 0.5
        viewSeekSlider.layer.shadowOffset = CGSize.zero
        viewSeekSlider.layer.shadowRadius = 5
        viewSeekSlider.layer.masksToBounds = false
        segmentControl.defaultConfiguration()
        segmentControl.selectedConfiguration()
        videoView.clipsToBounds = true
//        collectionViewReport.hide()
        collectionViewReport.delegate = self
        collectionViewReport.dataSource = self
        sliderSeekVideo.setThumbImage(UIImage(named: "seek.slider"), for: .normal)
        sliderSeekVideo.setThumbImage(UIImage(named: "seek.slider"), for: .highlighted)
        
        if currentVideoMode == .overlayVideo{
            // For Overlay Video
            print("Overlay Video")
            imgFrames.unhide()
            sliderSeekVideo.value = 0
            imgFrames.image = frames.first
            currentVideoMode = .overlayVideo
//            setFrames(videoMode: .overlayVideo)
            setVideo(videoMode: .overlayVideo)
            
        }else{
            // For Original Video
            print("Original Video")
            
            sliderSeekVideo.value = 0
//            setFrames(videoMode: .originalVideo)
            setVideo(videoMode: .originalVideo)
            
            var name: String = ""
            if ((capture?.overlayUrl.isEmpty) != nil){
                name = capture?.videoName ?? ""
            }else{
                name = capture?.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            }
            
        }
        
        if (Global.shared.selectedCapture.swingTypeId == 0) || (Global.shared.selectedCapture.swingTypeId == 1){
            // For Full Swing
            arrViewPositions.forEach { eachView in
                if (eachView.tag == 9) {
                    eachView.isHidden = true
                }else{
                    eachView.isHidden = false
                }
            }
            
        }else if (Global.shared.selectedCapture.swingTypeId == 3){
            // For Putting
            arrViewPositions.forEach { eachView in
                if (eachView.tag == 5) || (eachView.tag == 6) || (eachView.tag == 7) || (eachView.tag == 8) || (eachView.tag == 9) || (eachView.tag == 10) {
                    eachView.isHidden = true
                }else{
                    eachView.isHidden = false
                }
            }
        }
    }
    
    override func handleLeftEdge(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    func removeIrrelevantFrames(){
        if let points = highlightPoints{
            if !frames.isEmpty{
                if let p1 = points.p1, let p10 = points.p10{
                    
                    if (p10 <= frames.count) && (p10 > points.p9 ?? 0){
                        frames.removeLast(frames.count - p10)
                    }
                    frames.removeFirst(p1 - 1)
                }
                
                self.sliderSeekVideo.maximumValue = frames.count.toFloat()
            }
        }
    }
    
    func setupSeekSlider(){
        
        // If we have points and description already
        if let points = highlightPoints, let recordingDesc = recordingDesc {
            
//            removeIrrelevantFrames()
            
            // If we have frames already
            if !(frames.isEmpty) && (frames.count == recordingDesc.arrDescription.count){
                
                for (index, frame) in frames.enumerated(){
                    let temp: SeekSliderData = SeekSliderData(frameImage: frame)
                    print("Seek Slider Index: \(index)")
                    
                    temp.arrReport = recordingDesc.arrDescription[index]
                    self.arrSeekSliderData.append(temp)

                }
                DispatchQueue.main.async {
                    self.sliderSeekVideo.maximumValue = self.arrSeekSliderData.count.toFloat() - 1
                    self.collectionViewReport.unhide()
                }
                
            }
            
        }
    }
    
    // MARK: Get Highlights
    func getHighlights() {
        
        if let capture = capture {
            
            var userId: String = ""
            var fileId: String = ""
            
            var videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            if capture.overlayUrl.isEmpty{
                // If user comes directly from processing screen and he has to save a downloaded video
                videoId = self.videoOverlayUrl?.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            }else{
                // If user comes from history screen and he has to save a downloaded video
                videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            }
            
            // If striker will be received it means that a coach is trying to open a strikers video. If not then a user is trying to open his own videos
            if let striker = striker {
                userId = striker.userId
                fileId = "\(striker.useremail.lowercased())/\(videoId).json"
            } else{
                userId = Global.shared.loginUser?.userId ?? ""
                fileId = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
            }
            
            let params = ["loggedUserId" : userId, "fileId": fileId]
            
            
//            self.showIndicator(withTitle: "Fetching Highlights")
            ServiceManager.shared.getHighlights(parameters: params) { reportJson in
                
                print(reportJson)
                if let values = reportJson.arrayValue.first{
                    RecordingReportConstants.arrReport[0].reading = values["Start_to_impact_time"].doubleValue.toString(decimalPlaces: 2)
                    RecordingReportConstants.arrReport[1].reading = values["Back_swing_time"].doubleValue.toString(decimalPlaces: 2)
                    RecordingReportConstants.arrReport[2].reading = values["downswing_time"].doubleValue.toString(decimalPlaces: 2)
                    RecordingReportConstants.arrReport[3].reading = values["tempo"].doubleValue.toString(decimalPlaces: 1) + ":1"
                    RecordingReportConstants.arrReport[4].reading = values["Hand_Path_Back_Swing"].doubleValue.toString(decimalPlaces: 1)
                    RecordingReportConstants.arrReport[5].reading = values["Hand_Path_Down_Swing"].doubleValue.toString(decimalPlaces: 1)
                    RecordingReportConstants.arrReport[6].reading = values["Max_Hand_Speed"].doubleValue.toString(decimalPlaces: 1)
                    RecordingReportConstants.arrReport[7].reading = values["Max_UT_turn"].doubleValue.toString(decimalPlaces: 2)
                    RecordingReportConstants.arrReport[8].reading = values["Max_Pelvis_Turn"].doubleValue.toString(decimalPlaces: 2)
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.dataHighlights = RecordingReportConstants.arrReport
//                    self.setupSeekSlider()
//                    self.collectionViewReport.unhide()
                    self.heightCollectionView.constant = ceil(Double((self.dataHighlights?.count.toFloat() ?? 0.0)/3.0)) * 70
                    
                    DispatchQueue.main.async {
                        self.collectionViewReport.reloadData()
                    }
                    
                })
                
//                self.hideIndicator()
            } failure: { error in
                self.collectionViewReport.hide()
//                self.hideIndicator()
                self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
            }
        }
    }
    
    // MARK: Get Description
    func getDescription(){
        
        if let capture = capture {
            
            let bodyPartId: String = "-1"
            var userId: String = ""
            var fileId: String = ""
            
            var videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            if capture.overlayUrl.isEmpty{
                // If user comes directly from processing screen and he has to save a downloaded video
                videoId = self.videoOverlayUrl?.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            }else{
                // If user comes from history screen and he has to save a downloaded video
                videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            }
            
            // If striker will be received it means that a coach is trying to open a strikers video. If not then a user is trying to open his own videos
            if let striker = striker {
                userId = striker.userId
                fileId = "\(striker.useremail.lowercased())/\(videoId).json"
            } else{
                userId = Global.shared.loginUser?.userId ?? ""
                fileId = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
            }
            
            let params = ["fileId" : fileId, "bodyPartId": bodyPartId]
            
            ServiceManager.shared.getDescription(parameters: params) { [self] desc in
                print(desc)
                
//                self.viewPositions.unhide()
//                self.stackViewSlider.unhide()
                
                self.recordingDesc = RecordingDescription(json: desc)
                self.recordingDescBase = self.recordingDesc
                self.collectionViewDataDescription = recordingDesc?.arrDescription.first
                
                self.viewVerticalForceSlider.unhide()
                self.sliderVerticalForceBase?.value = recordingDesc?.verticalForce.first?.toFloat() ?? 0.0
                
                // Find the lowest and highest value of vertical force
                var arrVerticalForce = [Double]()
                recordingDesc?.verticalForce.forEach({ eachVerticalForce in
                    arrVerticalForce.append(eachVerticalForce.toDouble())
                })
//                self.txtMinVerticalForce.text = (arrVerticalForce.min()?.toString(decimalPlaces: 1) ?? "0")
//                self.txtMaxVerticalForce.text = (arrVerticalForce.max()?.toString(decimalPlaces: 1) ?? "0")
//                self.sliderVerticalForce.minimumValue = arrVerticalForce.min()?.toFloat() ?? 0.0
//                self.sliderVerticalForce.maximumValue = arrVerticalForce.max()?.toFloat() ?? 0.0
                
                let showSwipeGif = userDefault.getValue(key: UDKey.showReportGif) as? Bool
                showSwipeGif == true ? print("") : self.loadAndShowGif(gifName: "swipeLeft")
                userDefault.saveValue(value: true as Any, key: UDKey.showReportGif)
                
                self.collectionViewReport.unhide()
                sliderSeekVideo.isUserInteractionEnabled = true
                self.setupSeekSlider()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.collectionViewReport.reloadData()
                })

            } failure: { error in
                self.collectionViewReport.hide()
//                self.hideIndicator()
                self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
            }
        }
        
    }
    
    // MARK: Get Highlights 2
//    func getHighlights2(){
//        let userId: String = Global.shared.loginUser?.userId ?? ""
//        let fileId: String = "\(Global.shared.loginUser?.email ?? "")/\(capture?.videoName ?? "").json"
//
//        let params = ["loggedUserId" : userId, "fileId": fileId]
//
////        self.showIndicator(withTitle: "Fetching Highlights")
//
//        ServiceManager.shared.getHighlights2(parameters: params) { [self] highlightsJson in
//            print(highlightsJson)
//
//            highlights2 = RecordingHighlights2(json: highlightsJson)
//
//            self.collectionViewReport.unhide()
//            sliderSeekVideo.isUserInteractionEnabled = true
//
//            self.hideIndicator()
//        } failure: { error in
//            self.collectionViewReport.hide()
//            self.hideIndicator()
//            self.showPopupAlert(title: "Error", message: error.message) {}
//        }
//    }
    
    // MARK: Get Highlight Positions
//    func getHighlightPoints(){
//        let userId: String = Global.shared.loginUser?.userId ?? ""
//        let videoId = capture?.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
//        let fileId: String = "\(Global.shared.loginUser?.email ?? "")/\(videoId).json"
//
//        let params = ["loggedUserId" : userId, "fileId": fileId]
//
//        self.showIndicator(withTitle: "Fetching Highlight Points")
//
//        ServiceManager.shared.getHighlightPositions(parameters: params) { highlightsPointsJson in
//            print(highlightsPointsJson)
//            self.highlightPoints = HighlightPoints(json: highlightsPointsJson)
////            self.assignRespectiveImages()
//            self.setupSeekSlider()
//            self.hideIndicator()
//        } failure: { error in
//
//            self.hideIndicator()
//            self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
//        }
//    }
    
    // MARK: HELPERS
    func highlightP1ToP10(sliderValue: Int) {
        
        self.viewP1.borderColor = sliderValue == (highlightPoints?.p1 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP2.borderColor = sliderValue == (highlightPoints?.p2 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP3.borderColor = sliderValue == (highlightPoints?.p3 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP4.borderColor = sliderValue == (highlightPoints?.p4 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP5.borderColor = sliderValue == (highlightPoints?.p5 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP6.borderColor = sliderValue == (highlightPoints?.p6 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP7.borderColor = sliderValue == (highlightPoints?.p7 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP8.borderColor = sliderValue == (highlightPoints?.p8 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP9.borderColor = sliderValue == (highlightPoints?.p9 ?? 0) ? .reportGreen : .fenrisBlue
        self.viewP10.borderColor = sliderValue == (highlightPoints?.p10 ?? 0) ? .reportGreen : .fenrisBlue
    }
    
    func highlightPointButton(tag: Int){
        
        for eachButton in btnPoints{
            if eachButton.tag == tag{
                // Make border green
                eachButton.borderColor = .reportGreen
            }else{
                eachButton.borderColor = .reportBlue
            }
        }
    }
    
    func assignRespectiveImages() {
        
        // For P1
        if frames.count > (highlightPoints?.p1 ?? 0) && (highlightPoints?.p1 ?? 0) > 0{
            self.imgP1.image = frames[highlightPoints?.p1 ?? 0]
        }else{
            self.imgP1.image = UIImage(named: "P1")
        }
        
        // For P2
        if frames.count > (highlightPoints?.p2 ?? 0) && (highlightPoints?.p2 ?? 0) > 0{
            self.imgP2.image = frames[(highlightPoints?.p2 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP2.image = UIImage(named: "P2")
        }
        
        // For P3
        if frames.count > (highlightPoints?.p3 ?? 0) && (highlightPoints?.p3 ?? 0) > 0{
            self.imgP3.image = frames[(highlightPoints?.p3 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP3.image = UIImage(named: "P3")
        }
        
        // For P4
        if frames.count > (highlightPoints?.p4 ?? 0) && (highlightPoints?.p4 ?? 0) > 0{
            self.imgP4.image = frames[(highlightPoints?.p4 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP4.image = UIImage(named: "P4")
        }
        
        // For P5
        if frames.count > (highlightPoints?.p5 ?? 0) && (highlightPoints?.p5 ?? 0) > 0{
            self.imgP5.image = frames[(highlightPoints?.p5 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP5.image = UIImage(named: "P5")
        }
        
        // For P6
        if frames.count > (highlightPoints?.p6 ?? 0) && (highlightPoints?.p6 ?? 0) > 0{
            self.imgP6.image = frames[(highlightPoints?.p6 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP6.image = UIImage(named: "P6")
        }
        
        // For P7
        if frames.count > (highlightPoints?.p7 ?? 0) && (highlightPoints?.p7 ?? 0) > 0{
            self.imgP7.image = frames[(highlightPoints?.p7 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP7.image = UIImage(named: "P7")
        }
        
        // For P8
        if frames.count > (highlightPoints?.p8 ?? 0) && (highlightPoints?.p8 ?? 0) > 0{
            self.imgP8.image = frames[(highlightPoints?.p8 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP8.image = UIImage(named: "P8")
        }
        
        // For P9
        if frames.count > (highlightPoints?.p9 ?? 0) && (highlightPoints?.p9 ?? 0) > 0{
            self.imgP9.image = frames[(highlightPoints?.p9 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP9.image = UIImage(named: "P9")
        }
        
        // For P10
        if frames.count > (highlightPoints?.p10 ?? 0) && (highlightPoints?.p10 ?? 0) > 0{
            self.imgP10.image = frames[(highlightPoints?.p10 ?? 0) - (highlightPoints?.p1 ?? 0)]
        }else{
            self.imgP10.image = UIImage(named: "P10")
        }
        
    }
    
    //MARK: Download Video
    func downloadVideo(videoDownloadUrl: String) {
        print(videoDownloadUrl)
        
//        self.hideIndicator()
//        self.showIndicator(withTitle: "Downloading Video")
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: "\(videoDownloadUrl)")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                    if statusCode == 404 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.downloadVideo(videoDownloadUrl: videoDownloadUrl)
                        })
                        return
                    } else if statusCode == 200 {
                        // When video is downloaded successfully
                        self.downloadTimer?.invalidate()
                        
                        if self.currentVideoMode == .overlayVideo{
                            self.isOverlayDownloaded = true
                        }else{
                            self.isOriginalVideoDownloaded = true
                        }
                        self.getHighlightPoints()
                        self.locallySaveAndPlayVideo(url: tempLocalUrl)
                        self.downloadTimer?.invalidate()
                    }
                }
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
    
    //MARK: Locally save and play
//    func locallySaveAndPlayVideo(url: URL){
//
//        if let urlData = NSData(contentsOf: url) {
//            print(url)
//
//            var name: String = ""
//            if let capture = capture{
//                if capture.overlayUrl.isEmpty{
//                    // If user comes directly from processing screen and he has to save a downloaded video
//                    name = self.videoOverlayUrl?.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
//                }else{
//                    // If user comes from history screen and he has to save a downloaded video
//                    name = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
//                }
//            }
//
//
//            // Saving Video with respective names
//            if currentVideoMode == .originalVideo{
//                DocumentDirectory.saveData(data: urlData as Data, name: name)
//            }else if currentVideoMode == .overlayVideo{
//
//                DocumentDirectory.saveData(data: urlData as Data, name: "\(name)-overlay")
//            }
//
//            self.hideIndicator()
//            self.showIndicator(withTitle: "Extracting Frames")
//
//            // For original video
//            if currentVideoMode == .originalVideo{
////                setVideo(videoMode: .originalVideo)
//                setFrames(videoMode: .originalVideo)
//
//            }
//            // For overlay video
//            else{
////                setVideo(videoMode: .overlayVideo)
//                setFrames(videoMode: .overlayVideo)
//
//            }
//
//        }
//    }
    
    
    //MARK: AVPlayer status changed
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if player.rate == 0 {
                imgPlayPause.image = UIImage(systemName: "play.fill")
            } else if player.rate > 0{
                imgPlayPause.image = UIImage(systemName: "pause.fill")
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        isOverlayPlaying = false
        isOriginalVideoPlaying = false
        self.overlayFrameChangeTimer.invalidate()
        downloadTimer?.invalidate()
        imgPlayPause.image = UIImage(systemName: "play.fill")
        player.seek(to: .zero)
        sliderSeekVideo.value = 0
    }
    
    
//    func setFrames(videoMode: VideoMode){
//
//        if let capture = capture{
//
//            var extention: String = ""
//            if videoMode == .overlayVideo{
//                extention = "-overlay"
//            }
//
//            var videoId: String = ""
//            // if overlay url is empty then pick local video from video capture.videoName
//            if (capture.overlayUrl.isEmpty){
//                videoId = capture.videoName.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
//            }else{
//                videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
//            }
//
//            self.frames.removeAll()
//            self.frames = [UIImage]()
//
//            // For checking if the video is in Documents Directory
//            if let videoData = DocumentDirectory.getData(using: videoId + extention).0 {
//                print("Video Fetched from document directory")
//
//                if let highlightPoints = highlightPoints{
//
//                    // GETTING FRAMES
//                    self.videoManager = VideoManager()
//                    self.videoManager?.getFrames(data: videoData, points: highlightPoints) { [self] fetchedFrames in
//
//                        self.frames = fetchedFrames
//
//                        if currentVideoMode == .overlayVideo{
//                            isOverlayFramesExtracted = true
//                            isOriginalFramesExtracted = false
//                        }else{
//                            isOverlayFramesExtracted = false
//                            isOriginalFramesExtracted = true
//                        }
//
//                        DispatchQueue.main.async { [self] in
//                            if currentVideoMode == .originalVideo{
//                                self.imgFrames.image = self.frames.first?.rotate(radians: .pi/2)
//                            }else{
//                                self.imgFrames.image = self.frames.first
//                            }
//                            self.hideIndicator()
//                        }
//
//                        self.videoManager = nil
//                    }
//
//                }
//            }
//        }
//    }
    
    //MARK: ACTIONS
    @IBAction func seekSliderValueChanged(_ sender: UISlider) {
        
        print("Finger slided at: \(sender.value)")
        
        //for description
        if !frames.isEmpty{
            
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[sender.value.toInt()].toFloat() ?? 0.0
            
            if sender.value.toInt() < frames.count{
                
                if currentVideoMode == .originalVideo{
                    imgFrames.image = self.frames[sender.value.toInt()].rotate(radians: .pi/2)
                }else{
                    imgFrames.image = self.frames[sender.value.toInt()]
                }
                
                
            }
            
            self.highlightP1ToP10(sliderValue: sliderSeekVideo.value.toInt())
            
            // If there is no report
            if sliderSeekVideo.value.toInt() < arrSeekSliderData.count{
                collectionViewDataDescription = arrSeekSliderData[sliderSeekVideo.value.toInt()].arrReport
            }
            

            DispatchQueue.main.async {
                self.collectionViewReport.reloadData()
//                let indexPath: [IndexPath] = [IndexPath(item: 1, section: 0)]
//                self.collectionViewReport.reloadItems(at: indexPath)
            }
            
        }
        
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
//        frames.removeAll()
//        self.frames = [UIImage()]
//        self.overlayFrameChangeTimer.invalidate()
//        downloadTimer?.invalidate()
//        SDImageCache.shared.clearMemory()
//        imgPlayPause.image = UIImage(systemName: "play.fill")
//        sliderSeekVideo.value = 0
//        self.frames.removeAll()
//        self.frames = [UIImage()]

        self.frames.removeAll()
        self.frames = [UIImage()]
        self.imgFrames.image = UIImage()
        self.overlayFrameChangeTimer.invalidate()
        player.seek(to: .zero)
        sliderSeekVideo.value = 0
        imgPlayPause.image = UIImage(systemName: "play.fill")
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            // For Video
            print("Original Video")
            
            currentVideoMode = .originalVideo
            self.setVideo(videoMode: .originalVideo)
            
        case 1:
            
            // For Overlay Video
            print("Overlay Video")
            
            imgFrames.unhide()
            viewVideoPlayer.hide()
            imgFrames.image = frames.first
            sliderSeekVideo.value = 0
            viewPositions.unhide()
            viewFrameUp.unhide()
            viewFrameDown.unhide()
            
            player.pause()
            currentVideoMode = .overlayVideo
            self.setVideo(videoMode: .overlayVideo)
            
            
        default:
            break
        }
    }
    
    @IBAction func btnFrameDownClicked(_ sender: Any) {
        var currentIndex = self.sliderSeekVideo.value
        currentIndex-=1
        
        if (currentIndex >= 0){
            if (currentIndex.toInt() < frames.count) && (sliderSeekVideo.value.toInt() < arrSeekSliderData.count){
                
                self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[currentIndex.toInt()].toFloat() ?? 0.0
                self.sliderSeekVideo.setValue(currentIndex, animated: true)
                collectionViewDataDescription = arrSeekSliderData[sliderSeekVideo.value.toInt()].arrReport
//                DispatchQueue.main.async {
//                    self.collectionViewReport.reloadData()
//                }
                
                DispatchQueue.main.async {
                    self.collectionViewReport.reloadData()
//                    let indexPath: [IndexPath] = [IndexPath(item: 1, section: 0)]
//                    self.collectionViewReport.reloadItems(at: indexPath)
                }
                
                if currentVideoMode == .originalVideo{
                    imgFrames.image = self.frames[currentIndex.toInt()].rotate(radians: .pi/2)
                }else{
                    imgFrames.image = self.frames[currentIndex.toInt()]
                }
            }else{
                currentIndex = frames.count.toFloat() - 1
            }
        } else{
            currentIndex = 0
        }
    }
    
    @IBAction func btnFrameUpClicked(_ sender: Any) {
        var currentIndex = self.sliderSeekVideo.value
        currentIndex+=1
        
        if (currentIndex >= 0){
            if (currentIndex.toInt() < frames.count) && (sliderSeekVideo.value.toInt() < arrSeekSliderData.count){
                
                self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[currentIndex.toInt()].toFloat() ?? 0.0
                self.sliderSeekVideo.setValue(currentIndex, animated: true)
                collectionViewDataDescription = arrSeekSliderData[sliderSeekVideo.value.toInt()].arrReport
//                DispatchQueue.main.async {
//                    self.collectionViewReport.reloadData()
//                }
                DispatchQueue.main.async {
                    self.collectionViewReport.reloadData()
//                    let indexPath: [IndexPath] = [IndexPath(item: 1, section: 0)]
//                    self.collectionViewReport.reloadItems(at: indexPath)
                }
                
                if currentVideoMode == .originalVideo{
                    imgFrames.image = self.frames[currentIndex.toInt()].rotate(radians: .pi/2)
                }else{
                    imgFrames.image = self.frames[currentIndex.toInt()]
                }
            }else{
                currentIndex = frames.count.toFloat() - 1
            }
        } else{
            currentIndex = 0
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnRecordVideoClicked(_ sender: Any) {
        
        self.frames.removeAll()
        
        // If weight is added already
        if let isWeightAdded = userDefault.getValue(key: UDKey.isRecordingWeightAdded) as? Bool{
            
            let rootVC = RecordingVC.initFrom(storyboard: .recording)
            
            rootVC.isFromReportScreen = true
            rootVC.selectedOrientation = .faceOn
            Global.shared.selectedOrientation = PlayerOrientation(id: "2", name: "FaceOn")
            
            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.navigationBar.isHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else{
            let rootVC = RecordingWeightVC.initFrom(storyboard: .recording)
            rootVC.isRecord = true
            rootVC.isFromHistory = true
            
            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.navigationBar.isHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    
    @IBAction func btnPointsClicked(_ sender: UIButton) {
        print(sender.tag)
        
        highlightPointButton(tag: sender.tag)
        self.self.overlayFrameChangeTimer.invalidate()
        self.downloadTimer?.invalidate()
        imgPlayPause.image = UIImage(systemName: "play.fill")
        // For original video
        if currentVideoMode == .originalVideo{
            isOriginalVideoPlaying = !isOriginalVideoPlaying
        }else{
            // For overlay video
            isOverlayPlaying = !isOverlayPlaying
        }
        
        //for description
        if !frames.isEmpty{
            if sender.tag >= 0 && sender.tag < frames.count{
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[sender.tag].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[sender.tag]
                }
                
            }
            
        }
        
        if sender.tag == 1{
            var index = (highlightPoints?.p1 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 2{
            var index = (highlightPoints?.p2 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 3{
            var index = (highlightPoints?.p3 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 4{
            var index = (highlightPoints?.p4 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 5{
            var index = (highlightPoints?.p5 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 6{
            var index = (highlightPoints?.p6 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 7{
            var index = (highlightPoints?.p7 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 8{
            var index = (highlightPoints?.p8 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 9{
            var index = (highlightPoints?.p9 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            
            if (index == frames.count) || (index >= arrSeekSliderData.count){
                index -= 1
            }
            
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        } else if sender.tag == 10{
            var index = (highlightPoints?.p10 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            if index < 0 || index >= frames.count || index >= arrSeekSliderData.count {
                return
            }
            sliderSeekVideo.value = index.toFloat()
            collectionViewDataDescription = self.arrSeekSliderData[index].arrReport
            self.sliderVerticalForce.value  = self.recordingDesc?.verticalForce[index].toFloat() ?? 0.0
            
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames[index].rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames[index]
            }
            
        }
        
        DispatchQueue.main.async {
            self.collectionViewReport.reloadData()
//            let indexPath: [IndexPath] = [IndexPath(item: 1, section: 0)]
//            self.collectionViewReport.reloadItems(at: indexPath)
        }
        
    }
    
    @IBAction func btnPlayPauseClicked(_ sender: Any) {
        
        // For original video
        if currentVideoMode == .originalVideo{
            
            // For original video
            isOriginalVideoPlaying = !isOriginalVideoPlaying
            
            if isOriginalVideoPlaying {
                //                player.play()
                
                overlayFrameChangeTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(frameChangeTimeAction), userInfo: nil, repeats: true)
                
                imgPlayPause.image = UIImage(systemName: "pause.fill")
            } else {
                player.pause()
                overlayFrameChangeTimer.invalidate()
                imgPlayPause.image = UIImage(systemName: "play.fill")
            }
            
            
        }else{
            // For overlay video
            isOverlayPlaying = !isOverlayPlaying
            self.sliderSeekVideo.maximumValue = frames.count.toFloat()
            
            if isOverlayPlaying {
                overlayFrameChangeTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(frameChangeTimeAction), userInfo: nil, repeats: true)
                imgPlayPause.image = UIImage(systemName: "pause.fill")
            } else {
                overlayFrameChangeTimer.invalidate()
                imgPlayPause.image = UIImage(systemName: "play.fill")
            }
        }
    }

}

// MARK: COLLECTION VIEW METHODS
extension RecordingReportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath == [0,0]{
            // For Static values
            let cell = collectionView.dequeueReusableCell(with: RecordingHighlightCollectionViewCell.self, for: indexPath)
            if let data = dataHighlights{
                cell.setupCell(recordingReport: data)
            }
            return cell
        } else {
            // For Changing values
            let cell = collectionView.dequeueReusableCell(with: RecordingMultipleHighlightCollectionViewCell.self, for: indexPath)

            if let data = collectionViewDataDescription{
                cell.setupCell(recordingReport: data)
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = collectionView.frame.height
        let cellWidth = collectionView.frame.width
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionViewReport.visibleCells {
            currentIndexPath = collectionViewReport.indexPath(for: cell)!
        }
        collectionViewReport.reloadData()
    }
}

extension RecordingReportViewController: updateReportProtocol {
    func updateReport(index: Int) {
        if index < arrSeekSliderData.count{
            collectionViewDataDescription = arrSeekSliderData[index].arrReport
        }
        
        DispatchQueue.main.async {
            self.collectionViewReport.reloadData()
        }
    }
    
    func allFramesExtracted() {
        self.setupSeekSlider()
//        DispatchQueue.main.async {
//            self.collectionViewReport.reloadData()
//        }
    }
}
