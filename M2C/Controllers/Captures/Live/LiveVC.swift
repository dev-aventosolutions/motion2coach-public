//
//  LiveVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 15/06/2022.
//

import AVFoundation
import CoreVideo
import MLImage
import MLKit

class LiveVC: BaseVC {
    
    
    private let detectors: [Detector] = [
        .pose,
        .poseAccurate,
    ]
    
    private var currentDetector: Detector = .poseAccurate
    private var isUsingFrontCamera = false
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    
    private lazy var previewOverlayView: UIImageView = {
        
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    /// Initialized when one of the pose detector rows are chosen. Reset to `nil` when neither are.
    private var poseDetector: PoseDetector? = nil
    
    
    /// The detector mode with which detection was most recently run. Only used on the video output
    /// queue. Useful for inferring when to reset detector instances which use a conventional
    /// lifecyle paradigm.
    private var lastDetector: Detector?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    
    @IBOutlet weak var txtPelvisBend: UILabel!
    @IBOutlet weak var txtPelvisTilt: UILabel!
    @IBOutlet weak var txtPelvisTurn: UILabel!
    @IBOutlet weak var txtValueShoulderTilt: UILabel!
    @IBOutlet weak var txtValueShoulderTurn: UILabel!
    @IBOutlet weak var txtValueShoulderBend: UILabel!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
        
        self.view.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.isHidden = false
        startSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
        previewLayer.contentsScale = .greatestFiniteMagnitude
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSession()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func selectDetector(_ sender: Any) {
        presentDetectorsAlertController()
    }
    
    @IBAction func btnFlipCameraClicked(_ sender: Any) {
        isUsingFrontCamera = !isUsingFrontCamera
        removeDetectionAnnotations()
        setUpCaptureSessionInput()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigateBack()
    }
    
    // MARK: On-Device Detections
    
    private func detectPose(in image: MLImage, width: CGFloat, height: CGFloat) {
        if let poseDetector = self.poseDetector {
            var poses: [Pose] = []
            var detectionError: Error?
            do {
                poses = try poseDetector.results(in: image)
            } catch let error {
                detectionError = error
            }
            weak var weakSelf = self
            DispatchQueue.main.sync {
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                strongSelf.updatePreviewOverlayViewWithLastFrame()
                if let detectionError = detectionError {
                    print("Failed to detect poses with error: \(detectionError.localizedDescription).")
                    return
                }
                guard !poses.isEmpty else {
                    print("Pose detector returned no results.")
                    return
                }
                
                // Pose detected. Currently, only single person detection is supported.
                poses.forEach { pose in
                    let poseOverlayView = UIUtilities.createPoseOverlayView(
                        forPose: pose,
                        inViewWithBounds: strongSelf.annotationOverlayView.bounds,
                        lineWidth: Constant.lineWidth,
                        dotRadius: Constant.smallDotRadius,
                        positionTransformationClosure: { (position) -> CGPoint in
                            return strongSelf.normalizedPoint(
                                fromVisionPoint: position, width: width, height: height)
                        }
                    )
                    strongSelf.annotationOverlayView.addSubview(poseOverlayView)
                }
                
                for pose in poses {
                    
                    // eye landmark
                    let leftEyeLandMark = pose.landmark(ofType: .leftEye)
                    let rightEyeLandMark = pose.landmark(ofType: .rightEye)
                    
                    txtPelvisTurn.text = String(describing: calculateBodyMeasurements(pose: pose, measurement: .pelvisTurn).roundToDecimal(2)) + "°"
                    txtPelvisTilt.text = String(describing: calculateBodyMeasurements(pose: pose, measurement: .pelvisTilt).roundToDecimal(2)) + "°"
                    txtValueShoulderTurn.text = String(describing: calculateBodyMeasurements(pose: pose, measurement: .shoulderTurn).roundToDecimal(2)) + "°"
                    txtValueShoulderTilt.text = String(describing: calculateBodyMeasurements(pose: pose, measurement: .shoulderTilt).roundToDecimal(2)) + "°"
                }
            }
        }
    }
    
    // MARK: - Calculat Body Measurements
    fileprivate func calculateBodyMeasurements(pose: Pose, measurement: BodyMeasurement) -> Double{
        var leftHipX: CGFloat?
        var leftHipY: CGFloat?
        var leftHipZ: CGFloat?
        var rightHipX: CGFloat?
        var rightHipY: CGFloat?
        var rightHipZ: CGFloat?
        
        var leftShoulderX: CGFloat?
        var leftShoulderY: CGFloat?
        var leftShoulderZ: CGFloat?
        var rightShoulderX: CGFloat?
        var rightShoulderY: CGFloat?
        var rightShoulderZ: CGFloat?
        
        let leftHipLandMark = pose.landmark(ofType: .leftHip)
        leftHipX = leftHipLandMark.position.x
        leftHipY = leftHipLandMark.position.y
        leftHipZ = leftHipLandMark.position.z
//        if leftHipLandMark.inFrameLikelihood > 0.5 {
//            leftHipX = leftHipLandMark.position.x
//            leftHipY = leftHipLandMark.position.y
//            leftHipZ = leftHipLandMark.position.z
//        }
        
        let rightHipLandMark = pose.landmark(ofType: .rightHip)
        rightHipX = rightHipLandMark.position.x
        rightHipY = rightHipLandMark.position.y
        rightHipZ = rightHipLandMark.position.z
//        if rightHipLandMark.inFrameLikelihood > 0.5 {
//            rightHipX = rightHipLandMark.position.x
//            rightHipY = rightHipLandMark.position.y
//            rightHipZ = rightHipLandMark.position.z
//        }
        
        let leftShoulderLandMark = pose.landmark(ofType: .leftShoulder)
        leftShoulderX = leftShoulderLandMark.position.x
        leftShoulderY = leftShoulderLandMark.position.y
        leftShoulderZ = leftShoulderLandMark.position.z
//        if leftShoulderLandMark.inFrameLikelihood > 0.5 {
//            leftShoulderX = leftShoulderLandMark.position.x
//            leftShoulderY = leftShoulderLandMark.position.y
//            leftShoulderZ = leftShoulderLandMark.position.z
//        }
        
        let rightShoulderLandMark = pose.landmark(ofType: .rightShoulder)
        rightShoulderX = rightShoulderLandMark.position.x
        rightShoulderY = rightShoulderLandMark.position.y
        rightShoulderZ = rightShoulderLandMark.position.z
//        if rightShoulderLandMark.inFrameLikelihood > 0.5 {
//            rightShoulderX = rightShoulderLandMark.position.x
//            rightShoulderY = rightShoulderLandMark.position.y
//            rightShoulderZ = rightShoulderLandMark.position.z
//        }
        
        if let leftHipX = leftHipX, let leftHipY = leftHipY, let leftHipZ = leftHipZ, let rightHipX = rightHipX, let rightHipY = rightHipY, let rightHipZ = rightHipZ {
            if measurement == .pelvisTurn{
                return (90 - atan2(leftHipX - rightHipX, leftHipZ - rightHipZ).toDouble())
            } else if measurement == .pelvisTilt{
                return (90 - atan2(leftHipX - rightHipX, leftHipY - rightHipY).toDouble())
            }
            return 0
        }
        
        if let leftShoulderX = leftShoulderX, let leftShoulderY = leftShoulderY, let leftShoulderZ = leftShoulderZ, let rightShoulderX = rightShoulderX, let rightShoulderY = rightShoulderY, let rightShoulderZ = rightShoulderZ {
            if measurement == .shoulderTurn{
                return (90 - atan2(leftShoulderX - rightShoulderX, leftShoulderZ - rightShoulderZ).toDouble())
            } else if measurement == .shoulderTilt{
                return (90 - atan2(leftShoulderX - rightShoulderX, leftShoulderY - rightShoulderY).toDouble())
            }
            return 0
        }
        
        return 0
    }
    

    
    
    // MARK: - Private
    
    private func setUpCaptureSessionOutput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            //      strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            output.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
            guard strongSelf.captureSession.canAddOutput(output) else {
                print("Failed to add capture session output.")
                return
            }
            strongSelf.captureSession.addOutput(output)
            strongSelf.captureSession.commitConfiguration()
        }
    }
    
    private func setUpCaptureSessionInput() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            let cameraPosition: AVCaptureDevice.Position = strongSelf.isUsingFrontCamera ? .front : .back
            guard let device = strongSelf.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                strongSelf.captureSession.beginConfiguration()
                let currentInputs = strongSelf.captureSession.inputs
                for input in currentInputs {
                    strongSelf.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard strongSelf.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                strongSelf.captureSession.addInput(input)
                strongSelf.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        weak var weakSelf = self
        sessionQueue.async {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.stopRunning()
        }
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        NSLayoutConstraint.activate([
            previewOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            previewOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
            
        ])
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
        ])
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: self.isUsingFrontCamera ? .front : .back
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
    
    private func presentDetectorsAlertController() {
        let alertController = UIAlertController(
            title: Constant.alertControllerTitle,
            message: Constant.alertControllerMessage,
            preferredStyle: .alert
        )
        weak var weakSelf = self
        detectors.forEach { detectorType in
            let action = UIAlertAction(title: detectorType.rawValue, style: .default) {
                [unowned self] (action) in
                guard let value = action.title else { return }
                guard let detector = Detector(rawValue: value) else { return }
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                strongSelf.currentDetector = detector
                strongSelf.removeDetectionAnnotations()
            }
            if detectorType.rawValue == self.currentDetector.rawValue { action.isEnabled = false }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: Constant.cancelActionTitleText, style: .cancel))
        present(alertController, animated: true)
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func updatePreviewOverlayViewWithLastFrame() {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return
        }
        self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
        self.removeDetectionAnnotations()
    }
    
    private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
        guard let imageBuffer = imageBuffer else {
            return
        }
        let orientation: UIImage.Orientation = isUsingFrontCamera ? .leftMirrored : .right
        let image = UIUtilities.createUIImage(from: imageBuffer, orientation: orientation)
        previewOverlayView.image = image
    }
    
    private func convertedPoints(
        from points: [NSValue]?,
        width: CGFloat,
        height: CGFloat
    ) -> [NSValue]? {
        return points?.map {
            let cgPointValue = $0.cgPointValue
            let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
            let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            let value = NSValue(cgPoint: cgPoint)
            return value
        }
    }
    
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
    ) -> CGPoint {
        let cgPoint = CGPoint(x: point.x, y: point.y)
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
    
    /// Resets any detector instances which use a conventional lifecycle paradigm. This method is
    /// expected to be invoked on the AVCaptureOutput queue - the same queue on which detection is
    /// run.
    private func resetManagedLifecycleDetectors(activeDetector: Detector) {
        if activeDetector == self.lastDetector {
            // Same row as before, no need to reset any detectors.
            return
        }
        // Clear the old detector, if applicable.
        switch self.lastDetector {
        case .pose, .poseAccurate:
            self.poseDetector = nil
            break
        default:
            break
        }
        // Initialize the new detector, if applicable.
        switch activeDetector {
        case .pose, .poseAccurate:
            // The `options.detectorMode` defaults to `.stream`
            let options = activeDetector == .pose ? PoseDetectorOptions() : AccuratePoseDetectorOptions()
            self.poseDetector = PoseDetector.poseDetector(options: options)
            break
        default:
            break
        }
        self.lastDetector = activeDetector
    }
    
    private func rotate(_ view: UIView, orientation: UIImage.Orientation) {
        var degree: CGFloat = 0.0
        switch orientation {
        case .up, .upMirrored:
            degree = 90.0
        case .rightMirrored, .left:
            degree = 180.0
        case .down, .downMirrored:
            degree = 270.0
        case .leftMirrored, .right:
            degree = 0.0
        }
        view.transform = CGAffineTransform.init(rotationAngle: degree * 3.141592654 / 180)
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension LiveVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        // Evaluate `self.currentDetector` once to ensure consistency throughout this method since it
        // can be concurrently modified from the main thread.
        let activeDetector = self.currentDetector
        resetManagedLifecycleDetectors(activeDetector: activeDetector)
        
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = UIUtilities.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        visionImage.orientation = orientation
        
        guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
            print("Failed to create MLImage from sample buffer.")
            return
        }
        inputImage.orientation = orientation
        
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        var shouldEnableClassification = false
        var shouldEnableMultipleObjects = false
        
        
        switch activeDetector {
        case .pose, .poseAccurate:
            detectPose(in: inputImage, width: imageWidth, height: imageHeight)
        case .segmentationSelfie:
            print("Segmentation Selfie")
        }
    }
}

// MARK: - Constants

public enum Detector: String {
    
    case pose = "Pose Detection"
    case poseAccurate = "Pose Detection, accurate"
    case segmentationSelfie = "Selfie Segmentation"
}

private enum Constant {
    static let alertControllerTitle = "Vision Detectors"
    static let alertControllerMessage = "Select a detector"
    static let cancelActionTitleText = "Cancel"
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let noResultsMessage = "No Results"
    static let localModelFile = (name: "bird", type: "tflite")
    static let labelConfidenceThreshold = 0.75
    static let smallDotRadius: CGFloat = 8.0
    static let lineWidth: CGFloat = 5.0
    static let originalScale: CGFloat = 1.0
    static let padding: CGFloat = 10.0
    static let resultsLabelHeight: CGFloat = 200.0
    static let resultsLabelLines = 5
    static let imageLabelResultFrameX = 0.4
    static let imageLabelResultFrameY = 0.1
    static let imageLabelResultFrameWidth = 0.5
    static let imageLabelResultFrameHeight = 0.8
    static let segmentationMaskAlpha: CGFloat = 0.5
}

enum BodyMeasurement{
    case pelvisTurn
    case shoulderTurn
    case pelvisTilt
    case shoulderTilt
}
