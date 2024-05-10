//
//  RecordingSettingsVC.swift
//  M2C
//
//  Created by Abdul Samad Butt on 15/08/2022.
//

import UIKit
import AVKit
import DTTextField
import SPAlert
import StepSlider

protocol RecordingSettingsProtocol: AnyObject{
    func selectedRecordingSettings(videoSettings: VideoRecordingSettings)
}

class RecordingSettingsVC: BaseVC {

    // MARK: OUTLETS
    @IBOutlet weak var inputNumOfVideos: UITextField!
    @IBOutlet weak var viewNumOfVideos: UIView!
    @IBOutlet weak var inputHeightUnit: UITextField!
    @IBOutlet weak var switchContinousRecord: UISwitch!
    @IBOutlet weak var inputFrameRate: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var inputWeightUnit: UITextField!
    @IBOutlet weak var inputHeight: UITextField!
    @IBOutlet weak var txtShutterSpeedFrontCam: UILabel!
    @IBOutlet weak var txtIsoFrontCam: UILabel!
    @IBOutlet weak var txtShutterSpeedRearCam: UILabel!
    @IBOutlet weak var txtIsoRearCam: UILabel!
//    @IBOutlet weak var sliderIsoFrontCam: UISlider!
//    @IBOutlet weak var sliderShutterSpeedFrontCam: UISlider!
//    @IBOutlet weak var sliderIsoRearCam: UISlider!
//    @IBOutlet weak var sliderShutterSpeedRearCam: UISlider!
    
    @IBOutlet weak var sliderIsoRearCam: StepSlider!
    @IBOutlet weak var sliderShutterSpeedRearCam: StepSlider!
    @IBOutlet weak var sliderIsoFrontCam: StepSlider!
    @IBOutlet weak var sliderShutterSpeedFrontCam: StepSlider!
    @IBOutlet weak var viewRearCamSettings: UIView!
    @IBOutlet weak var viewFrontCamSettings: UIView!
    @IBOutlet weak var switchManualDetect: UISwitch!
    
    
    // MARK: VARIABLES
    var pickerViewNumOfVideos = UIPickerView()
    var pickerFrameRate = UIPickerView()
    var frameRatePickerIndex: Int = 0
    var numOfVideosPickerIndex: Int = 0
    weak var delegate: RecordingSettingsProtocol?
    var videoSettings: VideoRecordingSettings = VideoRecordingSettings()
    var synthesizer = AVSpeechSynthesizer()
    var selectedWeightUnit = "kg"
    var selectedHeighUnit = "cm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.sliderIsoFrontCam.labels = VideoSettings.arrIsoFrontCam
        self.sliderShutterSpeedFrontCam.labels = VideoSettings.arrShutterSpeedFrontCam
        
        self.sliderIsoRearCam.labels = VideoSettings.arrIsoRearCam
        self.sliderShutterSpeedRearCam.labels = VideoSettings.arrShutterSpeedRearCam
        
        
    }
    
    private func setupUI(){
        self.inputFrameRate.delegate = self
        self.inputNumOfVideos.delegate = self
        self.pickerFrameRate.delegate = self
        self.pickerFrameRate.dataSource = self
        self.pickerViewNumOfVideos.delegate = self
        self.pickerViewNumOfVideos.dataSource = self
        self.inputFrameRate.inputView = pickerFrameRate
        self.inputNumOfVideos.inputView = pickerViewNumOfVideos
        self.inputNumOfVideos.text = VideoSettings.numOfVideos.first
        self.inputFrameRate.text = VideoSettings.frameRates.first
        
        self.switchManualDetect.isOn = self.videoSettings.isManualDetect
        
        self.videoSettings = userDefault.getSavedVideoSettings(key: UDKey.videoSettings)
        
        self.txtShutterSpeedFrontCam.text = "Shutter Speed (\(videoSettings.shutterSpeedFrontCam))"
        self.txtIsoFrontCam.text = "ISO (\(videoSettings.isoFrontCam))"
        self.txtShutterSpeedRearCam.text = "Shutter Speed (\(videoSettings.shutterSpeedRearCam))"
        self.txtIsoRearCam.text = "ISO (\(videoSettings.isoRearCam))"
        
        self.sliderShutterSpeedFrontCam.index = VideoSettings.arrShutterSpeedFrontCam.firstIndex(where: { $0 == videoSettings.shutterSpeedFrontCam.toString() })?.toUInt() ?? 0
        self.sliderIsoFrontCam.index = VideoSettings.arrIsoFrontCam.firstIndex(where: { $0 == videoSettings.isoFrontCam.toString() })?.toUInt() ?? 0
        self.sliderShutterSpeedRearCam.index = VideoSettings.arrShutterSpeedRearCam.firstIndex(where: { $0 == videoSettings.shutterSpeedRearCam.toString() })?.toUInt() ?? 0
        self.sliderIsoRearCam.index = VideoSettings.arrIsoRearCam.firstIndex(where: { $0 == videoSettings.isoRearCam.toString() })?.toUInt() ?? 0
        
        self.switchContinousRecord.isOn = videoSettings.isCountinous
        self.viewNumOfVideos.isHidden = !switchContinousRecord.isOn
        self.inputNumOfVideos.text = videoSettings.numOfRecordings.toString()
        self.inputFrameRate.text = "\(videoSettings.frameRate) fps"
        
        // If striker is selected
        if let selectedStriker = Global.shared.selectedStriker{
            self.inputWeight.text = selectedStriker.weight
            self.inputHeight.text = selectedStriker.height
        }else{
            // If video is getting uploaded for user himself
            self.inputWeight.text = Global.shared.loginUser?.weight
            self.inputHeight.text = Global.shared.loginUser?.height
        }
        
        if Global.shared.loginUser?.roleName != "Coach"{
            self.viewFrontCamSettings.hide()
            self.viewRearCamSettings.hide()
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        self.alertSuccess(title: "", message: "Saving Camera Settings")
        
        // Saving weight and height for video
        var weight = inputWeight.text
        var height = inputHeight.text
        
        if selectedWeightUnit == "lb"{
            weight = inputWeight.text?.convertLbToKg()
        }
        if selectedHeighUnit == "ft"{
            height = inputHeight.text?.convertFtToCm()
        }
        
        // If striker is selected
        if Global.shared.selectedStriker != nil{
            Global.shared.selectedStriker?.weight = weight ?? "0"
            Global.shared.selectedStriker?.height = height ?? "0"
        }else{
            // If video is getting uploaded for user himself
            Global.shared.loginUser?.weight = weight ?? "0"
            Global.shared.loginUser?.height = height ?? "0"
            
            guard let user = Global.shared.loginUser else {return}
            userDefault.saveUser(user: user)
        }
        userDefault.saveValue(value: true as Any, key: UDKey.isRecordingWeightAdded)
        
        self.videoSettings.numOfRecordings = VideoSettings.numOfVideos[numOfVideosPickerIndex].toInt()
        self.videoSettings.frameRate = Int.parse(from: VideoSettings.frameRates[frameRatePickerIndex]) ?? 30
        self.videoSettings.isCountinous = switchContinousRecord.isOn
        
        // Temp
//        self.videoSettings.isManualDetect = true
        
        // Saving the settings in UD
        do {
            let encodedSettings = try NSKeyedArchiver.archivedData(withRootObject: videoSettings, requiringSecureCoding: true)
            userDefault.set(encodedSettings, forKey: UDKey.videoSettings)
            userDefault.synchronize()
        } catch{
            print("Unable to save video settings in UserDefaults")
        }
        
        
        if let del = delegate {
            
            self.popViewController()
            del.selectedRecordingSettings(videoSettings: self.videoSettings)
//            dismiss(animated: true) {
//                del.selectedRecordingSettings(videoSettings: self.videoSettings)
//            }
        }
    }
    
    @IBAction func switchContinousChanged(_ sender: Any) {
        self.videoSettings.isCountinous = switchContinousRecord.isOn
        self.viewNumOfVideos.isHidden = !switchContinousRecord.isOn
    }
    
    @IBAction func switchManualDetectChanged(_ sender: Any) {
        print("Switch changed")
        self.videoSettings.isManualDetect = switchManualDetect.isOn
    }
    
    @IBAction func sliderShutterSpeedFrontCamChanged(_ sender: StepSlider) {
        videoSettings.shutterSpeedFrontCam = VideoSettings.arrShutterSpeedFrontCam[Int(sender.index)].toInt()
        txtShutterSpeedFrontCam.text = "Shutter Speed (\(videoSettings.shutterSpeedFrontCam))"
    }
    
    @IBAction func sliderIsoFrontCamChanged(_ sender: StepSlider) {
        videoSettings.isoFrontCam = VideoSettings.arrIsoFrontCam[Int(sender.index)].toInt()
        txtIsoFrontCam.text = "ISO (\(videoSettings.isoFrontCam))"
    }
    
    
    @IBAction func sliderShutterSpeedRearCamChanged(_ sender: StepSlider) {
        videoSettings.shutterSpeedRearCam = VideoSettings.arrShutterSpeedRearCam[Int(sender.index)].toInt()
        txtShutterSpeedRearCam.text = "Shutter Speed (\(videoSettings.shutterSpeedRearCam))"
    }
    
    @IBAction func sliderIsoRearCamChanged(_ sender: StepSlider) {
        videoSettings.isoRearCam = VideoSettings.arrIsoRearCam[Int(sender.index)].toInt()
        txtIsoRearCam.text = "ISO (\(videoSettings.isoRearCam))"
    }
    
    
    
//    @IBAction func sliderShutterSpeedFrontCamChanged(_ sender: UISlider) {
//        txtShutterSpeedFrontCam.text = "Shutter Speed (\(videoSettings.shutterSpeedFrontCam))"
//        videoSettings.shutterSpeedFrontCam = sender.value.toInt()
//    }
    
    
//    @IBAction func sliderIsoFrontCamChanged(_ sender: UISlider) {
//        txtIsoFrontCam.text = "ISO (\(videoSettings.isoFrontCam))"
//        videoSettings.isoFrontCam = sender.value.toInt()
//    }
//
//    @IBAction func sliderShutterSpeedRearCamChanged(_ sender: UISlider) {
//        txtShutterSpeedRearCam.text = "Shutter Speed (\(videoSettings.shutterSpeedRearCam))"
//        videoSettings.shutterSpeedRearCam = sender.value.toInt()
//    }
//
//
//    @IBAction func sliderIsoRearCamChanged(_ sender: UISlider) {
//        txtIsoRearCam.text = "ISO (\(videoSettings.isoRearCam))"
//        videoSettings.isoRearCam = sender.value.toInt()
//    }
    
    
    @IBAction func actionSelectHeightUnit(_ sender: Any) {
        self.inputWeight.resignFirstResponder()
        let alert = UIAlertController(title: "Select Unit", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "cm", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "cm"
            self.inputHeightUnit.text = "cm"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "ft", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "ft"
            self.inputHeightUnit.text = "ft"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func actionSelectWeightUnit(_ sender: Any) {
        self.inputHeight.resignFirstResponder()
        let alert = UIAlertController(title: "Select Unit", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "kg", style: .default , handler:{ (UIAlertAction)in
            self.selectedWeightUnit = "kg"
            self.inputWeightUnit.text = "kg"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "lb", style: .default , handler:{ (UIAlertAction)in
            self.selectedWeightUnit = "lb"
            self.inputWeightUnit.text = "lb"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}

// MARK: PICKER VIEW METHODS
extension RecordingSettingsVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerFrameRate{
            return VideoSettings.frameRates.count
        }else if pickerView == pickerViewNumOfVideos{
            return VideoSettings.numOfVideos.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerFrameRate{
            return VideoSettings.frameRates[row]
        }else if pickerView == pickerViewNumOfVideos{
            return VideoSettings.numOfVideos[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerFrameRate{
            frameRatePickerIndex = row
            inputFrameRate.text = VideoSettings.frameRates[row]
        }else if pickerView == pickerViewNumOfVideos{
            numOfVideosPickerIndex = row
            inputNumOfVideos.text = VideoSettings.numOfVideos[row]
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == inputFrameRate{
            inputFrameRate.text = VideoSettings.frameRates[frameRatePickerIndex]
            videoSettings.frameRate = Int.parse(from: VideoSettings.frameRates[frameRatePickerIndex]) ?? 30
        }else if textField == inputNumOfVideos{
            inputNumOfVideos.text =  VideoSettings.numOfVideos[numOfVideosPickerIndex]
            videoSettings.numOfRecordings = VideoSettings.numOfVideos[numOfVideosPickerIndex].toInt()
        }
    }
}
