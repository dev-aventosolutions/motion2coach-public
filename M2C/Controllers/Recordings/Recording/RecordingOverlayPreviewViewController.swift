//
//  RecordingOverlayPreviewViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 16/09/2022.
//

import UIKit
import Photos
import AVKit

class RecordingOverlayPreviewViewController: RecordingBaseViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var viewPositions: UIView!
    @IBOutlet weak var viewFrameUp: UIView!
    @IBOutlet weak var viewFrameDown: UIView!
    @IBOutlet weak var sliderSeekVideo: UISlider!
    @IBOutlet weak var viewSeekSlider: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnFrameDown: UIButton!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnFrameUp: UIButton!
    @IBOutlet weak var imgPlayPause: UIImageView!
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var imgFrames: UIImageView!
    @IBOutlet var btnPoints: [UIButton]!
    @IBOutlet weak var btnEditPositions: UIButton!
    @IBOutlet var txtPoints: [UILabel]!
    @IBOutlet weak var btnCancelEditing: UIButton!
    @IBOutlet weak var txtCurrentFrames: UILabel!
    @IBOutlet var arrViewPositions: [UIView]!
    
    
    // MARK: VARIABLES
    var player = AVPlayer()
    var isEditMode: Bool = false
    var editingButtonTag: Int = 0
    var editedButtonsTag = Set<Int>()
    var panGesture = UIPanGestureRecognizer()
    let path = UIBezierPath()
    
    // MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sliderSeekVideoBase = self.sliderSeekVideo
        self.btnPlayPauseBase = self.btnPlayPause
        self.imgPlayPauseBase = self.imgPlayPause
        self.imgFramesBase = self.imgFrames
        self.viewIndicatorBase = self.viewIndicator
        self.txtCurrentFramesBase = self.txtCurrentFrames
        self.currentVideoMode = .originalVideo
        
        self.setupUI()
        if self.isOverlayDownloaded{
            //            getHighlightPoints()
        }
        self.downloadTimer?.invalidate()
        self.frames.removeAll()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.removeFrames), name: .removeFrames, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.processingView = ProcessingView.fromNib()
        self.view.addSubview(processingView!)
        self.processingView?.center = self.view.center
        self.getPointsRetryCounter = 0
        
        if isFirstTimeRecorded{
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.config()
        })
        
    }
    
    private func config(){
        // To extract frames for only one time
        if !isOverlayFramesExtracted || !isOriginalFramesExtracted{
            
            // For original video
            if currentVideoMode == .originalVideo{
                print("Original Video")
                
                sliderSeekVideo.value = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.setVideo(videoMode: .originalVideo)
                })
                segmentControl.selectedSegmentIndex = 0
                
            }
            // For overlay video
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.setVideo(videoMode: .overlayVideo)
                })
                segmentControl.selectedSegmentIndex = 1
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.frames.removeAll()
        self.frames = [UIImage]()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isFirstTimeRecorded{
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        overlayFrameChangeTimer.invalidate()
        downloadTimer?.invalidate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received in RecordingOverlayPreviewViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        frames.removeAll()
        //        self.frames = [UIImage()]
        overlayFrameChangeTimer.invalidate()
        downloadTimer?.invalidate()
        
    }
    
    deinit {
        self.frames.removeAll()
    }
    
    func setupUI(){
        
//        self.panGesture = UIPanGestureRecognizer(target: RecordingOverlayPreviewViewController.self, action: #selector(handlePanGesture(_:)))
//        self.imgFrames.addGestureRecognizer(panGesture)
        
        // For original video
        self.segmentControl.selectedSegmentIndex = currentVideoMode == .originalVideo ? 0 : 1
        self.viewSeekSlider.layer.shadowColor = UIColor.darkGray.cgColor
        self.viewSeekSlider.layer.shadowOpacity = 0.5
        self.viewSeekSlider.layer.shadowOffset = CGSize.zero
        self.viewSeekSlider.layer.shadowRadius = 5
        self.viewSeekSlider.layer.masksToBounds = false
        self.segmentControl.defaultConfiguration()
        self.segmentControl.selectedConfiguration()
        self.btnCancelEditing.hide()
        self.sliderSeekVideo.setThumbImage(UIImage(named: "seek.slider"), for: .normal)
        self.sliderSeekVideo.setThumbImage(UIImage(named: "seek.slider"), for: .highlighted)
        
        // Coach cannot change p-positions of striker
        if strikerBase != nil{
            //            self.btnEditPositions.hide()
        }
        
        // If user is coming from recording a new swing
        if let swingType = Global.shared.selectedSwingType{
            Global.shared.selectedCapture.swingTypeId = swingType.id?.toInt() ?? 0
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
    
    //MARK: Update Positions
    func updatePositions(){
        
        var videoId: String = ""
        // For getting highlight points from first time recording directly.
        if let overlayVideoUrl = videoOverlayUrl{
            videoId = overlayVideoUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
        }else{
            // For getting highlight points from history.
            videoId = capture?.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
        }
        
        var fileId: String = ""
        
        if let selectedUser = Global.shared.selectedStriker{
            fileId = "\(selectedUser.useremail.lowercased())/\(videoId).json"
        }else{
            fileId = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
        }
        
        let p1: Int = (editedHighlightPoints?.p1 ?? 0)
        let p2: Int = (editedHighlightPoints?.p2 ?? 0)
        let p3: Int = (editedHighlightPoints?.p3 ?? 0)
        let p4: Int = (editedHighlightPoints?.p4 ?? 0)
        let p5: Int = (editedHighlightPoints?.p5 ?? 0)
        let p6: Int = (editedHighlightPoints?.p6 ?? 0)
        let p7: Int = (editedHighlightPoints?.p7 ?? 0)
        let p8: Int = (editedHighlightPoints?.p8 ?? 0)
        let p9: Int = (editedHighlightPoints?.p9 ?? 0)
        let p10: Int = (editedHighlightPoints?.p10 ?? 0)
        
        let positions: [Int] = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10]
        
        let params = ["fileId": fileId, "positions": positions] as [String : Any]
        
        self.btnPoints.forEach { $0.isUserInteractionEnabled = true }
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.updatePositions, params: params, method: .post, type: "update_postions", loading: true, headerType: .headerWithAuth)
    }
    
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
        imgPlayPause.image = UIImage(systemName: "play.fill")
        player.seek(to: .zero)
        sliderSeekVideo.value = 0
    }
    
    
    //MARK: ACTIONS
    
    
    @IBAction func btnCancelEditingClicked(_ sender: Any) {
        self.isEditMode = false
        self.btnPoints.forEach { $0.backgroundColor = .white }
        self.txtPoints.forEach({ $0.textColor = .black })
        self.btnPoints.forEach { $0.isUserInteractionEnabled = true }
        self.editedButtonsTag.removeAll()
        self.btnEditPositions.setImage(UIImage(named: "edit.positions"), for: .normal)
        self.btnEditPositions.setTitle("", for: .normal)
        self.btnCancelEditing.hide()
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        self.imgFrames.image = UIImage()
        overlayFrameChangeTimer.invalidate()
        player.seek(to: .zero)
        sliderSeekVideo.value = 0
        imgPlayPause.image = UIImage(systemName: "play.fill")
        self.frames.removeAll()
        self.frames = [UIImage()]
        self.processingView?.isHidden = false
        
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
    
    //MARK: POINTS CLICKED
    @IBAction func btnPointsClicked(_ sender: UIButton) {
        print(sender.tag)
        
        self.overlayFrameChangeTimer.invalidate()
        imgPlayPause.image = UIImage(systemName: "play.fill")
        // For original video
        if currentVideoMode == .originalVideo{
            isOriginalVideoPlaying = !isOriginalVideoPlaying
        }else{
            // For overlay video
            isOverlayPlaying = !isOverlayPlaying
        }
        
        // Making all buttons red on each click, bacause only one
        if isEditMode{
            
            btnPoints.forEach { eachButton in
                eachButton.backgroundColor = .editPositionsRedColor
                self.editedButtonsTag.forEach { editedTag in
                    if eachButton.tag == editedTag{
                        eachButton.backgroundColor = .editPositionsGreenColor
                    }
                }
            }
            txtPoints.forEach({ $0.textColor = .white })
            
            
            // In the case of Full Swing only P1 and P10 will be disabled for editing
            if Global.shared.selectedSwingType?.id == "1"{
                btnPoints.forEach { button in
                    if button.tag == 1 || button.tag == 10{
                        button.backgroundColor = .lightGray
                        button.isUserInteractionEnabled = false
                    }
                }
            }else{
                // In the case of PUTTING, SHORT GAME and BUNKER only P1 and P4 will be disabled for editing
                btnPoints.forEach { button in
                    if button.tag == 1 || button.tag == 4{
                        button.backgroundColor = .lightGray
                        button.isUserInteractionEnabled = false
                    }
                }
            }
            
        }else{
            btnPoints.forEach { $0.backgroundColor = .white }
            txtPoints.forEach({ $0.textColor = .black })
        }
        
        // If we don't have to crop the irrelevant frames then exact frame indexes will be shown according to points from p1-p10
        // If we have to crop the irrelevant frames then value point P1 will be subtracted from each point. e.g p10-p1, p9-p1
        if sender.tag == 1{
            
            let index = (highlightPoints?.p1 ?? frames.count + 1) - (highlightPoints?.p1 ?? 0)
            if (index < 0 || index >= frames.count) {
                print("Value of p1 = \(index)")
                return
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            sliderSeekVideo.value = index.toFloat()
            
            if isEditMode{
                sender.backgroundColor = .editPositionsYellowColor
                editedHighlightPoints?.p1 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                print("P1 old value = \(highlightPoints?.p1 ?? 0) ... P1 new value = \(editedHighlightPoints?.p1 ?? 0)")
                
            }else{
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
        } else if sender.tag == 2{
            
            var index = (highlightPoints?.p2 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                print("Value of p2 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
                
            }
            
            if index < 0{
                print("Value of p2 = \(index)")
                return
            }
            
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                if self.editingButtonTag == 2{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedHighlightPoints?.p2 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    editedButtonsTag.insert(2)
                    print("P2 old value = \(highlightPoints?.p2 ?? 0) ... P2 new value = \(editedHighlightPoints?.p2 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 2
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
            
        } else if sender.tag == 3{
            
            var index = (highlightPoints?.p3 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                
                print("Value of p3 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                if self.editingButtonTag == 3{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(3)
                    editedHighlightPoints?.p3 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P3 old value = \(highlightPoints?.p3 ?? 0) ... P3 new value = \(editedHighlightPoints?.p3 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 3
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
        } else if sender.tag == 4{
            
            var index = (highlightPoints?.p4 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                print("Value of p4 = \(index)")
                return
                
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                if self.editingButtonTag == 4{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(4)
                    editedHighlightPoints?.p4 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P4 old value = \(highlightPoints?.p4 ?? 0) ... P4 new value = \(editedHighlightPoints?.p4 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 4
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
        } else if sender.tag == 5{
            
            var index = (highlightPoints?.p5 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                print("Value of p5 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                if self.editingButtonTag == 5{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(5)
                    editedHighlightPoints?.p5 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P5 old value = \(highlightPoints?.p5 ?? 0) ... P5 new value = \(editedHighlightPoints?.p5 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 5
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
        } else if sender.tag == 6{
            
            var index = (highlightPoints?.p6 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                
                print("Value of p6 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                
                if self.editingButtonTag == 6{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(6)
                    editedHighlightPoints?.p6 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P6 old value = \(highlightPoints?.p6 ?? 0) ... P6 new value = \(editedHighlightPoints?.p6 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 6
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
            
        } else if sender.tag == 7{
            
            var index = (highlightPoints?.p7 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                
                print("Value of p7 = \(index)")
                return
                
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                
                if self.editingButtonTag == 7{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(7)
                    editedHighlightPoints?.p7 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P7 old value = \(highlightPoints?.p7 ?? 0) ... P7 new value = \(editedHighlightPoints?.p7 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 7
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
        } else if sender.tag == 8{
            
            var index = (highlightPoints?.p8 ?? -1) - (highlightPoints?.p1 ?? 0)
            
            if index == frames.count{
                index -= 1
            }
            
            if (index < 0 || index >= frames.count) {
                
                print("Value of p8 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            if isEditMode{
                
                if self.editingButtonTag == 8{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(8)
                    editedHighlightPoints?.p8 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P8 old value = \(highlightPoints?.p8 ?? 0) ... P8 new value = \(editedHighlightPoints?.p8 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 8
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
            
        } else if sender.tag == 9{
            
            let index = (highlightPoints?.p9 ?? -1) - (highlightPoints?.p1 ?? 0)
            if (index < 0 || index >= frames.count) {
                
                print("Value of p9 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            
            
            if isEditMode{
                
                if self.editingButtonTag == 9{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedButtonsTag.insert(9)
                    editedHighlightPoints?.p9 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P9 old value = \(highlightPoints?.p9 ?? 0) ... P9 new value = \(editedHighlightPoints?.p9 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 9
                    self.sliderSeekVideo.value = index.toFloat()
                    if currentVideoMode == .originalVideo{
                        self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                    }else{
                        self.imgFrames.image = frames[index]
                    }
                }
                
            }else{
                sliderSeekVideo.value = index.toFloat()
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = frames[index].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = frames[index]
                }
            }
            
            
        } else if sender.tag == 10{
            
            let index = (highlightPoints?.p10 ?? -1) - (highlightPoints?.p1 ?? 0)
            if (index < 0 || index >= frames.count) {
                
                print("Value of p10 = \(index)")
                return
                //                if index < 0{
                //                    return
                //                }
                //                index = index - 1
            }
            txtCurrentFrames.text = "Frames \(index)/\(frames.count)"
            if currentVideoMode == .originalVideo{
                self.imgFrames.image = frames.last?.rotate(radians: .pi/2)
            }else{
                self.imgFrames.image = frames.last
            }
            
            if isEditMode{
                
                if self.editingButtonTag == 10{
                    // Actual editing mode
                    sender.backgroundColor = .editPositionsGreenColor
                    editedHighlightPoints?.p10 = sliderSeekVideo.value.toInt() + (highlightPoints?.p1 ?? 0)
                    print("P10 old value = \(highlightPoints?.p10 ?? 0) ... P10 new value = \(editedHighlightPoints?.p10 ?? 0)")
                }else{
                    // Ready to edit mode
                    sender.backgroundColor = .editPositionsYellowColor
                    self.editingButtonTag = 10
                    self.sliderSeekVideo.value = self.sliderSeekVideo.maximumValue
                }
                
            }else{
                self.sliderSeekVideo.value = self.sliderSeekVideo.maximumValue
            }
            
        }
    }
    
    //MARK: FRAME DOWN
    @IBAction func btnFrameDownClicked(_ sender: Any) {
        var currentIndex = self.sliderSeekVideo.value
        currentIndex-=1
        
        if (currentIndex >= 0){
            if (currentIndex.toInt() < frames.count){
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = self.frames[currentIndex.toInt()].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = self.frames[currentIndex.toInt()]
                }
                
                self.sliderSeekVideo.setValue(currentIndex, animated: true)
            }else{
                currentIndex = frames.count.toFloat() - 1
            }
        } else{
            currentIndex = 0
        }
    }
    
    //MARK: FRAME UP
    @IBAction func btnFrameUpClicked(_ sender: Any) {
        var currentIndex = self.sliderSeekVideo.value
        currentIndex+=1
        
        if (currentIndex >= 0){
            if (currentIndex.toInt() < frames.count){
                if currentVideoMode == .originalVideo{
                    self.imgFrames.image = self.frames[currentIndex.toInt()].rotate(radians: .pi/2)
                }else{
                    self.imgFrames.image = self.frames[currentIndex.toInt()]
                }
                self.sliderSeekVideo.setValue(currentIndex, animated: true)
            }else{
                currentIndex = frames.count.toFloat() - 1
            }
        } else{
            currentIndex = 0
        }
    }
    
    //MARK: SLIDER VALUE CHANGED
    @IBAction func seekSliderValueChanged(_ sender: UISlider) {
        
        print("Finger Slided at: \(sender.value.toInt())/\(frames.count)")
        txtCurrentFrames.text = "Frames \(sender.value.toInt())/\(frames.count)"
        // For original video
        if currentVideoMode == .originalVideo {
            
            if !frames.isEmpty{
                if sender.value.toInt() >= 0 && sender.value.toInt() < frames.count{
                    self.imgFrames.image = frames[sender.value.toInt()].rotate(radians: .pi/2)
                    
                }
            }
            
        }else {
            // For overlay video
            if !frames.isEmpty{
                if sender.value.toInt() >= 0 && sender.value.toInt() < frames.count{
                    self.imgFrames.image = frames[sender.value.toInt()]
                    
                }
            }
        }
        
    }
    
    //MARK: PLAY PAUSE ACTION
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
    
    //MARK: EDIT POSITIONS
    @IBAction func btnEditPositionsClicked(_ sender: Any) {
        
        self.editedButtonsTag.removeAll()
        if isEditMode{
            
            // Call Save points API
            self.isEditMode = false
            self.updatePositions()
            self.btnPoints.forEach { $0.backgroundColor = .white }
            self.txtPoints.forEach({ $0.textColor = .black })
            self.btnPoints.forEach { $0.isUserInteractionEnabled = true }
            self.btnEditPositions.setImage(UIImage(named: "edit.positions"), for: .normal)
            self.btnEditPositions.setTitle("", for: .normal)
            self.btnCancelEditing.hide()
            
        }else{
            
            self.showPopupAlert(title: "Edit Positions", message: "P1 and P10 can't be changed. Are you sure you want to edit the P Positions?", btnOkTitle: "Yes", btnCancelTitle: "No", onOK: { [self] in
                self.downloadTimer?.invalidate()
                // On Yes Clicked
                self.editingButtonTag = 0
                self.btnCancelEditing.unhide()
                self.isEditMode = true
                self.btnEditPositions.setImage(UIImage(named: ""), for: .normal)
                self.btnEditPositions.setTitle("Save", for: .normal)
                
                if isEditMode{
                    btnPoints.forEach { $0.backgroundColor = .editPositionsRedColor }
                    txtPoints.forEach({ $0.textColor = .white })
                    
                    // In the case of Full Swing only P1 and P10 will be disabled for editing
                    if Global.shared.selectedSwingType?.id == "1"{
                        btnPoints.forEach { button in
                            if button.tag == 1 || button.tag == 10{
                                button.backgroundColor = .lightGray
                                button.isUserInteractionEnabled = false
                            }
                        }
                    }else{
                        // In the case of PUTTING, SHORT GAME and BUNKER only P1 and P4 will be disabled for editing
                        btnPoints.forEach { button in
                            if button.tag == 1 || button.tag == 4{
                                button.backgroundColor = .lightGray
                                button.isUserInteractionEnabled = false
                            }
                        }
                    }
                }
                
            }, onCancel: { [self] in
                // On No Clicked
                self.isEditMode = false
                btnPoints.forEach { $0.isUserInteractionEnabled = true }
            })
        }
        
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if isFirstTimeRecorded{
            self.popBackToOrientationScreen()
        }else{
            self.popViewController()
            self.dismiss(animated: true)
        }
    }
}


//MARK: Image Drawing Methods
extension RecordingOverlayPreviewViewController {

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let image = self.imgFrames.image else {return}

        let point = sender.location(in: sender.view)

        let rx = image.size.width / self.imgFrames.frame.size.width
        let ry = image.size.height / self.imgFrames.frame.size.height

        let pointInImage = CGPoint(x: point.x * rx, y: point.y * ry)

        switch sender.state {
        case .began:
            self.startAtPoint(point: pointInImage)
        case .changed:
            self.continueAtPoint(point: pointInImage)
        case .ended:
            self.endAtPoint(point: pointInImage)
        case .failed:
            self.endAtPoint(point: pointInImage)
        default:
            assert(false, "State not handled")
        }
    }


    private func startAtPoint(point: CGPoint) {

        path.lineWidth = 5

        path.move(to: point)

    }

    private func continueAtPoint(point: CGPoint) {

        path.addLine(to: point)
    }

    private func endAtPoint(point: CGPoint) {

        path.addLine(to: point)

        path.addLine(to: point)
        //path.close()

        let imageWidth: CGFloat = imgFrames.image!.size.width
        let imageHeight: CGFloat  = imgFrames.image!.size.height
        let strokeColor:UIColor = UIColor.red

        // Make a graphics context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        context!.setStrokeColor(strokeColor.cgColor)

        //for path in paths {
        path.stroke()
        //}
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
    }
}
