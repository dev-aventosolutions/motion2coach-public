//
//  RecordingVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 12/05/2022.
//

import UIKit
import Photos
import CoreData
import MobileCoreServices
import SPAlert

protocol RecordingVCProtocol: AnyObject{
    func showSession()
}

class RecordingVC: BaseVC {
    
    //------------------------------------
    // MARK: IBOutlets
    //------------------------------------
    @IBOutlet weak var horiozontalSlider: UISlider!
    @IBOutlet weak var verticalSlider: UISlider!{
        didSet{
            verticalSlider.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi) / 2))
        }
    }
    @IBOutlet weak var btnFlipCamera: UIButton!
    @IBOutlet weak var txtFps: UILabel!
    @IBOutlet weak var viewVerticalRectangle: UIView!
    @IBOutlet weak var viewVerticalMovement: UIView!
    @IBOutlet weak var viewHoriozontalMovement: UIView!
    @IBOutlet weak var viewHoriozontalRectangle: UIView!
    @IBOutlet weak var constraintHoriozontalRecTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintVerticalRecTop: NSLayoutConstraint!
    @IBOutlet weak var viewTimerSettings: UIView!
    @IBOutlet weak var viewForCamera: PreviewView!
    @IBOutlet weak var overlayView: OverlayView!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var viewAudioButton: UIView!
    @IBOutlet weak var lblBodyDetected: UILabel!
    @IBOutlet weak var viewStopButton: UIView!
    @IBOutlet weak var txtStatusRecorded: UILabel!
    @IBOutlet weak var imgRecordVideo: UIImageView!
    @IBOutlet weak var viewBottomInfoText: UIView!
    @IBOutlet weak var lblBottomInfoText: UILabel!
    @IBOutlet weak var imgLoader: UIImageView!
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var lblGetReadyToSwing: UILabel!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var imgTimer: UIImageView!
    @IBOutlet weak var imgAudio: UIImageView!
    @IBOutlet weak var viewPressStopToEndRecording: UIView!
    @IBOutlet weak var txtCountDown: UILabel!
    @IBOutlet weak var txtSelectedTimer: UILabel!
    @IBOutlet weak var btnStartRecording: UIButton!
    @IBOutlet weak var btnSelectClub: UIButton!
    @IBOutlet weak var viewClubType: UIView!
    @IBOutlet weak var viewCameraSettings: UIView!
    @IBOutlet weak var txtBallDetected: UILabel!
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    var videoController: UIImagePickerController = UIImagePickerController()
    //    var overlayView = UIView()
    var isRecording = false
    var timer: Timer? = nil
    var counter = 0 // To decrement the timer
    var totalTimerCount = 3
    var videoSettings = VideoRecordingSettings()
    var recordedVideosCount = 0
    var synthesizer = AVSpeechSynthesizer()
    var isMuted: Bool = false
    var selectedOrientation: Orientation?
    weak var delegate: RecordingVCProtocol?
    var isFrontCam: Bool = false
    var isFromReportScreen: Bool = false
    
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var outputURL: URL!
    var activeInput: AVCaptureDeviceInput!
    var cameraPosition: AVCaptureDevice.Position = .back
    var previewLayer: AVCaptureVideoPreviewLayer!
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    var isBallDetected = false
    var ballNotDetectedCounter = 0
    var ballHittingTime: Double = 0
    
    var videoRecordingTimer: Timer? = nil
    var videoRecordingCounter: Double = 0
    
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    private let edgeOffset: CGFloat = 2.0
    private let labelOffset: CGFloat = 10.0
    private let animationDuration = 0.5
    private let collapseTransitionThreshold: CGFloat = -30.0
    private let expandTransitionThreshold: CGFloat = 30.0
    private let delayBetweenInferencesMs: Double = 200
    
    //------------------------------------
    // MARK: Object Detection Properties
    //------------------------------------
    // Holds the results at any time
    private var result: Result?
    private var previousInferenceTimeMs: TimeInterval = Date.distantPast.timeIntervalSince1970 * 1000
    
    
    // MARK: Controllers that manage functionality
    private var cameraFeedManager = CameraFeedManager()
    private var modelDataHandler: ModelDataHandler? =
    ModelDataHandler(modelFileInfo: Yolov5.modelInfo, labelsFileInfo: Yolov5.labelsInfo)
    
    
    //------------------------------------
    // MARK: Overriden Functions
    //------------------------------------
    
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = userDefault.getSavedVideoSettings(key: UDKey.videoSettings)
        self.videoSettings = settings
        
        // Temp
//        self.videoSettings.isManualDetect = true
        
        if self.videoSettings.isManualDetect{
            // For Manual Recording
            
        } else{
            // For AutoDetection
            self.cameraFeedManager = CameraFeedManager(previewView: viewForCamera)
            
            if setupSession(position: .back){
                DispatchQueue.main.async { [self] in
                    
                    // Configure previewLayer
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: cameraFeedManager.session)
                    self.previewLayer.frame = viewForCamera.bounds
                    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.previewLayer.connection?.videoOrientation = .portrait
                    //                self.previewView.previewLayer.connection?.videoOrientation = .portrait
                    //                self.previewView.previewLayer.videoGravity = .resizeAspectFill
                    self.viewForCamera.layer.addSublayer(previewLayer)
                    
                    self.cameraFeedManager.checkCameraConfigurationAndStartSession()
                }
            }
        }
    }
    
    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        
        self.timer?.invalidate()
        
        if self.videoSettings.isManualDetect{
            // For Manual Recording
            
            self.captureSession.stopRunning()
            // if user is not coming from report screen then load the session here.
            if !isFromReportScreen{
                if setupSession(position: .back){
                    
                    // Configure previewLayer
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    self.previewLayer.frame = viewForCamera.bounds
                    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.viewForCamera.layer.addSublayer(previewLayer)
                    
                    self.startSession()
                }
            }
        }else{
            // For Automatic detection
            self.timer?.invalidate()
            self.videoRecordingTimer?.invalidate()
            NotificationCenter.default.addObserver(self, selector: #selector(self.isBallMoved), name: .ballMoved, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.isBallNotMoved), name: .ballNotMoved, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.ballDetected), name: .ballDetected, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.ballNotDetected), name: .ballNotDetected, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.isVideoUploaded), name: .videoUploaded, object: nil)
            
            // Setting iso 450 because there is camera is not detecting the call on lower ISO i.e 50
            self.videoSettings.isoRearCam = 450
            
//            self.cameraFeedManager.checkCameraConfigurationAndStartSession()
        }
        
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layer = previewLayer{
            layer.frame = viewForCamera.bounds
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received in RecordingVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if videoSettings.isManualDetect{
            // For manual recording
            
        }else{
            // For auto ball detection
            self.cameraFeedManager.delegate = self
            self.overlayView.clearsContextBeforeDrawing = true
        }
    }
    
    func setupUI(){
        
        // Temporarily remove
        self.viewHoriozontalMovement.hide()
        self.viewVerticalMovement.hide()
        
        if self.videoSettings.isManualDetect{
            // Settings for Manual Detection
            self.horiozontalSlider.setThumbImage(UIImage(named: "rectangle.white"), for: .normal)
            self.horiozontalSlider.setThumbImage(UIImage(named: "rectangle.white"), for: .highlighted)
            self.verticalSlider.setThumbImage(UIImage(named: "rectangle.white"), for: .normal)
            self.verticalSlider.setThumbImage(UIImage(named: "rectangle.white"), for: .highlighted)
            self.verticalSlider.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi) / 2))
            
            self.btnSelectClub.setImage(UIImage(named: Global.shared.selectedClubType?.name ?? "Iron"), for: .normal)
            
            self.viewTimerSettings.hide()
            self.viewClubType.show()
            self.viewTimer.show()
            self.viewAudioButton.show()
            self.txtStatusRecorded.show()
            self.viewStopButton.show()
            self.txtBallDetected.text = ""
            
            self.txtSelectedTimer.text = " \(totalTimerCount)s"
            
            self.txtCountDown.hide()
            self.videoSettings.numOfRecordings = 1
            self.recordedVideosCount = 0
            self.txtStatusRecorded.text = "\(recordedVideosCount)/\(videoSettings.numOfRecordings) Recorded"
            self.txtFps.text = "• " + videoSettings.frameRate.toString() + " fps"
            
            if Global.shared.selectedSwingType?.id == "1"{
                print("Full Swing Selected")
                self.btnSelectClub.isUserInteractionEnabled = true
            }else{
                self.btnSelectClub.isUserInteractionEnabled = false
            }
            //        if selectedOrientation == .downTheLine{
            //            viewHoriozontalMovement.hide()
            //        } else if selectedOrientation == .faceOn{
            //            viewVerticalMovement.hide()
            //        }
            
            // HANDLE PINCH
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
            self.viewForCamera.addGestureRecognizer(pinchRecognizer)
            
        }else{
            // Settings for Auto Detection
            self.viewTimer.hide()
            self.viewTimerSettings.hide()
            self.viewAudioButton.hide()
            self.viewClubType.hide()
            self.txtStatusRecorded.hide()
            self.viewStopButton.show()
            self.txtBallDetected.text = "Scanning"
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer?.invalidate()
        self.videoRecordingTimer?.invalidate()
        self.cameraFeedManager.stopSession()
        self.stopSession()
        self.stopRecording()
        
        if self.videoSettings.isManualDetect{
            // For manual recording
            
        }else{
            // For Auto Ball Detection
            NotificationCenter.default.removeObserver("ballMoved")
            NotificationCenter.default.removeObserver("ballDetected")
            NotificationCenter.default.removeObserver("ballNotDetected")
            NotificationCenter.default.removeObserver("videoUploaded")
        }
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver("isAPICallStarted")
        NotificationCenter.default.removeObserver("isAPICallEnded")
        timer?.invalidate()
    }
    
    
    @objc func apiCallsStarted(){
        self.showIndicator(withTitle: "Uploading")
    }
    
    @objc func apiCallsEnded(){
        self.hideIndicator()
    }
    
    func noCamera() {
        print("This device has no camera")
    }
    
    @objc func actionReport(){
        self.navigateForward(storyBoard: SBCaptures, viewController: reportVCID)
    }
    
    @objc func actionRepeat(){
        timer?.invalidate()
        //    self.videoController.startVideoCapture()
    }
    
    @objc func actionVisualize(){
        self.navigateForward(storyBoard: SBCaptures, viewController: visualizationVCID)
    }
    
    //------------------------------------
    // MARK: IBActions
    //------------------------------------
    
    
    
    //MARK: Flip Camera
    @IBAction func btnFlipCameraClicked(_ sender: UIButton) {
        
        isFrontCam = !isFrontCam
        cameraPosition = isFrontCam ? .front: .back
        
        // Setup Camera
        var camera: AVCaptureDevice?
        
        // Check if iPhone's camera support Ultra wide angle camera
        if let ultraWideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition){
            camera = ultraWideCamera
        } else if let wideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition){
            camera = wideCamera
        }
        
        if let camera = camera{
            do {
                
                let currentInputs = captureSession.inputs
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                
                print(captureSession.inputs)
                let input = try AVCaptureDeviceInput(device: camera)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                }
            } catch {
                print("Error setting device video input: \(error)")
                
            }
        }
        
    }
    
    //MARK: Back
    @IBAction func actionCross(_ sender: UIButton) {
        if isFromReportScreen{
            AppDelegate.app.moveToDashboard()
        }else{
            self.videoController.dismiss(animated: true)
            timer?.invalidate()
            self.popViewController()
        }
    }
    
    //MARK: Mute Clicked
    @IBAction func btnAudioClicked(_ sender: Any) {
        print("Mute Clicked")
        
        isMuted = !isMuted
        if isMuted{
            imgAudio.image = UIImage(systemName: "speaker.slash.fill")
            synthesizer.stopSpeaking(at: .immediate)
        }else{
            imgAudio.image = UIImage(systemName: "speaker.wave.2")
            
        }
        
    }
    
    //MARK: Start Recording
    @IBAction func btnStartRecordingClicked(_ sender: Any) {
        
        if self.videoSettings.isManualDetect{
            // For Manual recording
            timer?.invalidate()
            txtCountDown.text = ""
            
            btnFlipCamera.isHidden = !btnFlipCamera.isHidden
            isRecording = !isRecording
            if isRecording{
                imgRecordVideo.image = UIImage(systemName: "stop.circle")
                startTimer(counterTime: totalTimerCount)
                txtCountDown.show()
            }else{
                imgRecordVideo.image = UIImage(systemName: "largecircle.fill.circle")
                timer?.invalidate()
            }
            
        } else {
            // For Auto Detection
            guard modelDataHandler != nil else {
                fatalError("Failed to load model")
            }
            
            self.isBallDetected = false
            timer?.invalidate()
            txtCountDown.text = ""
            
//            self.startSession()
            self.startVideoRecording()
            
            btnFlipCamera.isHidden = !btnFlipCamera.isHidden
            isRecording = !isRecording
            
            if isRecording{
                imgRecordVideo.image = UIImage(systemName: "stop.circle")
                //            startTimer(counterTime: totalTimerCount)
                txtCountDown.show()
            }else{
                imgRecordVideo.image = UIImage(systemName: "largecircle.fill.circle")
                timer?.invalidate()
                print("Session Stopped")
                stopRecording()
                stopSession()
                cameraFeedManager.delegate = nil
            }
        }
    }
    
    //MARK: Timer Settings
    @IBAction func btnTimerClicked(_ sender: Any) {
        self.viewStopButton.hide()
        self.viewTimer.hide()
        self.viewAudioButton.hide()
        self.viewTimerSettings.show()
        self.viewClubType.hide()
    }
    
    //MARK: Camera Settings
    @IBAction func btnSettingsClicked(_ sender: Any) {
        
        NotificationCenter.default.removeObserver("ballMoved")
        NotificationCenter.default.removeObserver("ballDetected")
        NotificationCenter.default.removeObserver("ballNotDetected")
        NotificationCenter.default.removeObserver("videoUploaded")
        
        
        self.stopRecording()
        
        self.recordedVideosCount = 0
        self.timer?.invalidate()
        self.txtCountDown.text = ""
        self.imgRecordVideo.image = UIImage(systemName: "largecircle.fill.circle")
        self.isRecording = false
        
        if videoSettings.isManualDetect{
            self.viewTimerSettings.hide()
            self.viewClubType.show()
            self.viewTimer.show()
            self.viewAudioButton.show()
            self.txtStatusRecorded.show()
            
        }else{
            self.viewTimerSettings.hide()
            self.viewClubType.hide()
            self.viewTimer.hide()
            self.viewAudioButton.hide()
            self.txtStatusRecorded.hide()
//            self.cameraFeedManager.stopSession()
            self.cameraFeedManager.delegate = nil
        }
        self.viewStopButton.show()
        
        let vc = RecordingSettingsVC.initFrom(storyboard: .recording)
        vc.videoSettings = self.videoSettings
        vc.delegate = self
        self.pushViewController(vc: vc)
//        self.present(vc, animated: true)
    }
    
    
    //MARK: Ball Moved
    @objc func isBallMoved(notification: Notification){
        
        print("Ball is moved")
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        //            self.movieOutput.stopRecording()
        //        })
    }
    
    //MARK: Ball Not Moved
    @objc func isBallNotMoved(notification: Notification){
        
    }
    
    //MARK: Ball Detected
    @objc func ballDetected(notification: Notification){
        
        print("Ball is Detected")
        self.isBallDetected = true
        self.txtBallDetected.text = "Ball Detected"
        self.ballNotDetectedCounter = 0
    }
    
    //MARK: Ball Not Detected
    @objc func ballNotDetected(notification: Notification){
        
        print("Ball Not Detected")
        //        self.isBallDetected = false
        self.txtBallDetected.text = "Scanning"
        
        if isRecording && isBallDetected{
            
            ballNotDetectedCounter = ballNotDetectedCounter + 1
            
            if ballNotDetectedCounter == 1{
                self.ballHittingTime = videoRecordingCounter
                print("Swing done at: \(ballHittingTime)")
                
            } else if ballNotDetectedCounter == 5{
                
                print("Video End")
                self.ballNotDetectedCounter = 0
                self.cameraFeedManager.delegate = nil
                self.stopRecording()
                self.stopSession()
            }
        }
    }
    
    @objc func isVideoUploaded(notification: Notification){
        
        print("Video Uploaded")
        self.hideIndicator()
        self.txtBallDetected.text = "Next Swing"
        self.cameraFeedManager.delegate = self
        self.startSession()
        self.startRecording()
    }
    
    
    @objc func updateVideoRecordingTimer() {
//        print(self.videoRecordingCounter)
        self.videoRecordingCounter = self.videoRecordingCounter + 0.1
        
    }
    
    func startTimer(counterTime: Int) {
        
        txtCountDown.show()
        self.counter = counterTime
        txtCountDown.text = self.counter.toString()
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func startVideoRecording(){
        
        if self.videoSettings.isManualDetect{
            // For manual recording
            
            imgRecordVideo.image = UIImage(systemName: "stop.circle")
            self.startRecording()
            
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(stopVideoRecord), userInfo: nil, repeats: true)
        }else{
            // For auto detection
            imgRecordVideo.image = UIImage(systemName: "stop.circle")
            switchFormat(withDesiredFPS: self.videoSettings.frameRate.toCgFloat())
            startRecording()
            
            self.timer?.invalidate()
            self.videoRecordingTimer?.invalidate()
            
            self.videoRecordingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateVideoRecordingTimer), userInfo: nil, repeats: true)
        }
        
        
    }
    
    @IBAction func btnTimerSecondsClicked(_ sender: UIButton) {
        
        if sender.tag == 0{
            self.totalTimerCount = 0
        }else if sender.tag == 3{
            self.totalTimerCount = 3
        }else if sender.tag == 5{
            self.totalTimerCount = 5
        }else if sender.tag == 10{
            self.totalTimerCount = 10
        }
        self.txtSelectedTimer.text = totalTimerCount == 0 ? " Off" : " \(totalTimerCount)s"
        self.viewTimerSettings.hide()
        self.viewStopButton.show()
        self.viewTimer.show()
        self.viewAudioButton.show()
        self.viewClubType.show()
    }
    
    @IBAction func btnSelectClubClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Club Type", message: "Current selected club is \(Global.shared.selectedClubType?.name ?? "Iron")", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Driver", style: .default , handler:{ (UIAlertAction)in
            
            Global.shared.selectedClubType = ClubType(id: "2", name: "Driver")
            self.btnSelectClub.setImage(UIImage(named: "Driver"), for: .normal)
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Iron", style: .default , handler:{ (UIAlertAction)in
            self.btnSelectClub.setImage(UIImage(named: "Iron"), for: .normal)
            Global.shared.selectedClubType = ClubType(id: "1", name: "Iron")
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    // MARK: PINCH
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        
        let device = activeInput.device
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
            print("Last Zoom Factor: \(lastZoomFactor)")
        default: break
        }
    }
    
    @objc func stopVideoRecord() {
        SpeechManager.shared.speakAudio(dialouge: "Finished")
        isRecording = !isRecording
        timer?.invalidate()
        imgRecordVideo.image = UIImage(systemName: "largecircle.fill.circle")
        recordedVideosCount+=1
        stopRecording()
        stopSession()
        btnFlipCamera.isHidden = !btnFlipCamera.isHidden
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            
            if isMuted{
                print("muted")
            }else{
                let utterance_3 = AVSpeechUtterance(string: self.counter.toString())
                utterance_3.preUtteranceDelay = 0
                utterance_3.voice = AVSpeechSynthesisVoice(language: "en-US")
                synthesizer.stopSpeaking(at: .word)
                synthesizer.speak(utterance_3)
            }
            
            self.txtCountDown.text = self.counter.toString()
        }
        
        counter = counter - 1
        
        if counter < 0{
            timer?.invalidate()
            startVideoRecording()
            txtCountDown.hide()
            viewTimerSettings.hide()
            
        }
    }
    
    
    func switchFormat(withDesiredFPS desiredFPS: CGFloat) {
        let isRunning = captureSession.isRunning
        if isRunning {
            captureSession.stopRunning()
        }
        //        let videoDevice = AVCaptureDevice.default(for: .video)
        
        // Setup Camera
        var camera: AVCaptureDevice?
        
        // Check if iPhone's camera support Ultra wide angle camera
        if let ultraWideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition){
            camera = ultraWideCamera
        } else if let wideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition){
            camera = wideCamera
        }
        
        var selectedFormat: AVCaptureDevice.Format? = nil
        var maxWidth: Int32 = 0
        var frameRateRange: AVFrameRateRange? = nil
        if let vDevice = camera {
            for format in vDevice.formats {
                for range in format.videoSupportedFrameRateRanges {
                    let desc = format.formatDescription
                    var dimensions: CMVideoDimensions? = nil
                    if let desc = desc as? CMVideoFormatDescription {
                        dimensions = CMVideoFormatDescriptionGetDimensions(desc)
                    }
                    if let dim = dimensions {
                        let width = dim.width
                        if (range.minFrameRate <= desiredFPS && desiredFPS <= range.maxFrameRate && width >= maxWidth) {
                            selectedFormat = format;
                            frameRateRange = range;
                            maxWidth = width;
                        }
                    }
                }
            }
            if (selectedFormat != nil) {
                try? vDevice.lockForConfiguration()
                if let format = selectedFormat {
                    vDevice.activeFormat = format
                }
                vDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFPS))
                vDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFPS))
                vDevice.unlockForConfiguration()
            }
            if isRunning {
                
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.startRunning()
                }
            }
        }
    }
}

// MARK: AVCapture Output
extension RecordingVC: AVCaptureFileOutputRecordingDelegate{
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("Video Recording Ended Delegate")
        
        if self.videoSettings.isManualDetect{
            // For Manual recording
            
            if (error != nil) {
                print("Error recording movie: \(error!.localizedDescription)")
            } else {
                
                do {
                    let videoData = try Data(contentsOf: self.outputURL)
                    if videoData.toAVAsset().duration.seconds <= 3.0{
                        
                        // If video is less than 3 seconds
                        try videoData.write(to: self.outputURL, options: .atomic)
                        self.timer?.invalidate()
                        self.txtStatusRecorded.text = "\(self.recordedVideosCount)/\(self.videoSettings.numOfRecordings) Recorded"
                        
                        if recordedVideosCount == videoSettings.numOfRecordings{
                            showVideoPreview(videoLink: outputURL, videoSettings: videoSettings) {
                                // Btn Retake
                                print("Retake")
                                self.startSession()
                                self.timer?.invalidate()
                                self.recordedVideosCount = 0
                                self.txtStatusRecorded.text = "\(self.recordedVideosCount)/\(self.videoSettings.numOfRecordings) Recorded"
                                self.viewStopButton.show()
                            }onViewSessions: {
                                self.timer?.invalidate()
                                let vc = ProcessingViewController.initFrom(storyboard: .captures)
                                vc.videoLocalUrl = self.outputURL
                                vc.videoBinaryData = videoData
                                vc.isVideoUploading = true
                                self.pushViewController(vc: vc)
                                
                            }
                        }
                        // If the recorded videos are less than the total num of recordings
                        else{
                            //                            stopRecording()
                            //                            CoreDataManager.shared.createCapture(url: outputURL, binary: videoData, dateAdded: Date())
                            //                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                            //                                timer?.invalidate()
                            //                                txtCountDown.text = ""
                            //                                isRecording = !isRecording
                            //                                if isRecording{
                            //                                    imgRecordVideo.image = UIImage(systemName: "stop.circle")
                            //                                    startTimer(counterTime: totalTimerCount)
                            //                                    txtCountDown.show()
                            //                                }else{
                            //                                    imgRecordVideo.image = UIImage(systemName: "largecircle.fill.circle")
                            //                                    timer?.invalidate()
                            //                                }
                            //                            }
                        }
                        
                    }else{
                        // If length of video is greater than 3
                        self.showPopupAlert(title: "Error", message: "Video cannot be longer than 3 seconds.")
                    }
                    
                } catch let err{
                    print(err.localizedDescription)
                }
                
            }
        } else{
            // For Auto detection
            if (error != nil) {
                print("Error recording movie: \(error!.localizedDescription)")
            } else {
                
                do {
                    
                    let player = AVPlayer(url: self.outputURL)
                    guard let asset = player.currentItem?.asset else { return }
                    
                    self.videoRecordingTimer?.invalidate()
                    self.trimAndExport(player: player, outputPath: self.outputURL, asset: asset, hittingTime: ballHittingTime) { [self] success in
                        do {
                            self.timer?.invalidate()
                            let videoData = try Data(contentsOf: self.outputURL)
                            try videoData.write(to: self.outputURL, options: .atomic)
                            self.txtStatusRecorded.text = "\(self.recordedVideosCount)/\(self.videoSettings.numOfRecordings) Recorded"
                            
                            self.showIndicator(withTitle: "Uploading Video")
                            self.cameraFeedManager.delegate = nil
                            self.stopRecording()
                            self.stopSession()
                            self.isBallDetected = false // Keeping it false so that for the next swing ball should be detected atleast for once
                            CoreDataManager.shared.createCapture(url: self.outputURL, binary: videoData, dateAdded: Date())
                        } catch let err{
                            print(err.localizedDescription)
                        }
                    }
                } catch let err{
                    print(err.localizedDescription)
                }
            }
        }
        
    }
    
    func startSession() {
        
        if !captureSession.isRunning {
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    
    func stopSession() {
        
        if self.videoSettings.isManualDetect{
            // For manual recording
            if captureSession.isRunning {
                videoQueue().async {
                    self.captureSession.stopRunning()
                }
            }
        }else{
            // For auto detection
            if cameraFeedManager.session.isRunning {
                videoQueue().async {
                    self.cameraFeedManager.session.stopRunning()
                }
            }
        }
        
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeRight
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.portrait
        }
        
        return orientation
    }
    
    @objc func startCapture() {
        startSession()
        
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            //            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            let path = directory.appendingPathComponent("m2c-iOS-\(Global.shared.loginUser?.userId ?? "")-\(Date.currentTimeStamp)" + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    // MARK: START RECORDING
    func startRecording() {
        self.btnStartRecording.isUserInteractionEnabled = false
        
        self.viewClubType.hide()
        self.viewTimer.hide()
        self.viewAudioButton.hide()
        self.viewCameraSettings.hide()
        
        if movieOutput.isRecording == false {
            movieOutput.movieFragmentInterval = CMTime.invalid
            let connection = movieOutput.connection(with: AVMediaType.video)
            if movieOutput.availableVideoCodecTypes.contains(.h264) {
                // Use the H.264 codec to encode the video.
                movieOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.h264], for: connection!)
            }
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = .off
            }
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    device.videoZoomFactor = lastZoomFactor
                } catch {
                    print("Error setting configuration: \(error)")
                }
            }
            
            if self.videoSettings.isManualDetect{
                SpeechManager.shared.speakAudio(dialouge: "Go")
            }
            
            self.outputURL = tempURL()
            self.movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
//            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
//
//
//            }
            
        }
        else {
            stopRecording()
            stopSession()
        }
    }
    
    func stopRecording() {
        self.btnStartRecording.isUserInteractionEnabled = true
        
        // For manual recording the video
        if self.videoSettings.isManualDetect{
            self.viewClubType.show()
            self.viewTimer.show()
            self.viewAudioButton.show()
            self.viewCameraSettings.show()
        }else{
            // For auto detection of the ball
            
        }
        
        if self.movieOutput.isRecording == true {
            self.isRecording = false
            self.movieOutput.stopRecording()
        }
    }
    
    func setupSession(position: AVCaptureDevice.Position) -> Bool {
        
        //        captureSession.sessionPreset = .hd1920x1080
        //        captureSession.sessionPreset = .iFrame1280x720
        //        captureSession.sessionPreset = .hd1280x720
        // Setup Camera
        var camera: AVCaptureDevice?
        
        // Check if
        if let ultraWideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position){
            camera = ultraWideCamera
        } else if let wideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position){
            camera = wideCamera
        }
        
        if let camera = camera{
            
            // 1
            for vFormat in camera.formats {
                //            print("vformats: \(camera.formats.count)")
                //            if let vFormat = camera.formats.last{
                
                print("Updating")
                // 2
                let ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
                let frameRates = ranges[0]
                // 3
                if frameRates.maxFrameRate >= 60 {
                    // 4
                    do {
                        try camera.lockForConfiguration()
                    } catch {
                        // handle error
                        return false
                    }
                    camera.activeFormat = vFormat as AVCaptureDevice.Format
                    
                    self.movieOutput.movieFragmentInterval = .init(seconds: 1.0, preferredTimescale: .min)
                    
                    
                    if let striker = Global.shared.selectedStriker {
                        // If video is getting uploaded for striker
                        
                        // Custom SS and ISO will be only for Coach
                        // If user is uploading video for himself
                        camera.exposureMode = .custom
                        if cameraPosition == .front{
                            camera.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(videoSettings.shutterSpeedFrontCam)), iso: Float(videoSettings.isoFrontCam))
                        }else if cameraPosition == .back{
                            var iso: Float = 0
                            if Float(videoSettings.isoRearCam) < vFormat.minISO{
                                iso = vFormat.minISO
                            }else{
                                iso = Float(videoSettings.isoRearCam)
                            }
                            camera.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(videoSettings.shutterSpeedRearCam)), iso: iso)
                        }
                        
                    }else{
                        if Global.shared.loginUser?.roleName == "Coach"{
                            // Custom SS and ISO will be only for Coach
                            // If user is uploading video for himself
                            camera.exposureMode = .custom
                            if cameraPosition == .front{
                                camera.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(videoSettings.shutterSpeedFrontCam)), iso: Float(videoSettings.isoFrontCam))
                            }else if cameraPosition == .back{
                                var iso: Float = 0
                                if Float(videoSettings.isoRearCam) < vFormat.minISO{
                                    iso = vFormat.minISO
                                }else{
                                    iso = Float(videoSettings.isoRearCam)
                                }
                                camera.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(videoSettings.shutterSpeedRearCam)), iso: iso)
                            }
                        } else{
                            // If user is Striker
                            camera.exposureMode = .continuousAutoExposure
                            
                        }
                        
                    }
                    
                    captureSession.sessionPreset = .hd1280x720

                    if camera.activeVideoMinFrameDuration.seconds > frameRates.minFrameRate{
                        camera.activeVideoMinFrameDuration = frameRates.minFrameDuration//CMTimeMake(value: 1, timescale: Int32(90))
                    }
                    
                    if camera.activeVideoMaxFrameDuration.seconds < frameRates.maxFrameRate{
                        camera.activeVideoMaxFrameDuration = frameRates.maxFrameDuration//CMTimeMake(value: 1, timescale: Int32(90))
                    }
                    
                    camera.unlockForConfiguration()
                }
            }
                

            do {
                
                let currentInputs = captureSession.inputs
                for input in currentInputs {
                    print("Removing input")
                    self.captureSession.removeInput(input)
                }
                
                print(captureSession.inputs)
                let input = try AVCaptureDeviceInput(device: camera)
                
                if captureSession.canAddInput(input) {
                    print("Adding input 1")
                    captureSession.addInput(input)
                    activeInput = input
                }
            } catch {
                print("Error setting device video input: \(error)")
                return false
            }
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            print("Adding input 2")
            captureSession.addOutput(movieOutput)
        }
        switchFormat(withDesiredFPS: self.videoSettings.frameRate.toCgFloat())
        return true
    }
}

// MARK: CameraFeedManagerDelegate Methods
extension RecordingVC: CameraFeedManagerDelegate {
    
    func didOutput(pixelBuffer: CVPixelBuffer) {
        //        print("did Output")
        
        self.runModel(onPixelBuffer: pixelBuffer)
        
        //        if framesSkippedCounter == 5{
        //            runModel(onPixelBuffer: pixelBuffer)
        //            framesSkippedCounter = 0
        //        }else if framesSkippedCounter != 5{
        //            framesSkippedCounter = framesSkippedCounter + 1
        //        }
        
    }
    
    // MARK: Session Handling Alerts
    func sessionRunTimeErrorOccurred() {
        
        // Handles session run time error by updating the UI and providing a button if session can be manually resumed.
        //    self.resumeButton.isHidden = false
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        
        // Updates the UI when session is interrupted.
        if resumeManually {
            //      self.resumeButton.isHidden = false
        }
        else {
            //      self.cameraUnavailableLabel.isHidden = false
        }
    }
    
    func sessionInterruptionEnded() {
        
        // Updates UI once session interruption has ended.
        //    if !self.cameraUnavailableLabel.isHidden {
        //      self.cameraUnavailableLabel.isHidden = true
        //    }
        
        //    if !self.resumeButton.isHidden {
        //      self.resumeButton.isHidden = true
        //    }
    }
    
    func presentVideoConfigurationErrorAlert() {
        
        let alertController = UIAlertController(title: "Configuration Failed", message: "Configuration of camera has failed.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentCameraPermissionsDeniedAlert() {
        
        let alertController = UIAlertController(title: "Camera Permissions Denied", message: "Camera permissions have been denied for this app. You can change this by going to Settings", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    /** This method runs the live camera pixelBuffer through tensorFlow to get the result.
     */
    @objc  func runModel(onPixelBuffer pixelBuffer: CVPixelBuffer) {
        
        // Run the live camera pixelBuffer through tensorFlow to get the result
        
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        guard  (currentTimeMs - previousInferenceTimeMs) >= delayBetweenInferencesMs else {
            return
        }
        
        previousInferenceTimeMs = currentTimeMs
        result = self.modelDataHandler?.runModel(onFrame: pixelBuffer)
        
        guard let displayResult = result else {
            return
        }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
    
        
        // Draws the bounding boxes and displays class names and confidence scores.
        DispatchQueue.main.async {

            // Draws the bounding boxes and displays class names and confidence scores.
            self.drawAfterPerformingCalculations(onInferences: displayResult.inferences, withImageSize: CGSize(width: CGFloat(width), height: CGFloat(height)))
        }
    }
    
    
    /**
     This method takes the results, translates the bounding box rects to the current view, draws the bounding boxes, classNames and confidence scores of inferences.
     */
    func drawAfterPerformingCalculations(onInferences inferences: [Inference], withImageSize imageSize:CGSize) {
        
        self.overlayView.objectOverlays = []
        self.overlayView.setNeedsDisplay()
        
        guard !inferences.isEmpty else {
            return
        }
        
        var objectOverlays: [ObjectOverlay] = []
        
        for inference in inferences {
            
            // Translates bounding box rect to current view.
            var convertedRect = inference.rect.applying(CGAffineTransform(scaleX: self.overlayView.bounds.size.width / imageSize.width, y: self.overlayView.bounds.size.height / imageSize.height))
            
            if convertedRect.origin.x < 0 {
                convertedRect.origin.x = self.edgeOffset
                print(convertedRect.origin.x)
            }
            
            if convertedRect.origin.y < 0 {
                convertedRect.origin.y = self.edgeOffset
                print(convertedRect.origin.y)
            }
            
            if convertedRect.maxY > self.overlayView.bounds.maxY {
                convertedRect.size.height = self.overlayView.bounds.maxY - convertedRect.origin.y - self.edgeOffset
            }
            
            if convertedRect.maxX > self.overlayView.bounds.maxX {
                convertedRect.size.width = self.overlayView.bounds.maxX - convertedRect.origin.x - self.edgeOffset
            }
            
            let confidenceValue = Int(inference.confidence * 100.0)
            let string = "\(inference.className)  (\(confidenceValue)%)"
            
            let size = string.size(usingFont: self.displayFont)
            
            let objectOverlay = ObjectOverlay(name: string, borderRect: convertedRect, nameStringSize: size, color: inference.displayColor, font: self.displayFont)
            
            objectOverlays.append(objectOverlay)
        }
        
        // Hands off drawing to the OverlayView
        self.draw(objectOverlays: objectOverlays)
        
    }
    
    /**
     Calls methods to update overlay view with detected bounding boxes and class names.
     **/
    func draw(objectOverlays: [ObjectOverlay]) {
        
        self.overlayView.objectOverlays = objectOverlays
        self.overlayView.setNeedsDisplay()
    }
}

extension RecordingVC: RecordingSettingsProtocol{
    func selectedRecordingSettings(videoSettings: VideoRecordingSettings) {
        print(videoSettings.numOfRecordings)
        print(videoSettings.frameRate)
        print(videoSettings.isCountinous)
        
        self.videoSettings = videoSettings
        self.txtFps.text = "• " + videoSettings.frameRate.toString() + " fps"
        
        txtSelectedTimer.text = " \(totalTimerCount)s"
        
        if videoSettings.isCountinous{
            txtStatusRecorded.text = "\(recordedVideosCount)/\(videoSettings.numOfRecordings) Recorded"
        } else{
            txtStatusRecorded.text = "\(recordedVideosCount)/1 Recorded"
        }
        
        if self.videoSettings.isManualDetect{
            // For Manual recording
            
            cameraPosition = isFrontCam ? .front: .back
            
            self.captureSession.stopRunning()
            cameraPosition = isFrontCam ? .front: .back
            if self.setupSession(position: cameraPosition) {
                self.startSession()
            }

            SPAlert.dismiss()
            
            self.cameraFeedManager.delegate = nil
        }else{
            // For auto ball detection
            self.videoRecordingTimer?.invalidate()
            self.cameraFeedManager.checkCameraConfigurationAndStartSession()
//            self.startSession()
            self.cameraFeedManager.delegate = self
            self.overlayView.clearsContextBeforeDrawing = true
        }
        
        self.setupUI()
    }
}
