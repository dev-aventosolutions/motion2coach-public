//
//  RecordingWeightVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 04/06/2022.
//

import UIKit
import DTTextField

class RecordingWeightVC: BaseVC {
    
    @IBOutlet weak var inputHeight: DTTextField!
    @IBOutlet weak var inputWeight: DTTextField!
    @IBOutlet weak var inputHeightUnit: UITextField!
    @IBOutlet weak var txtWeightUnit: UITextField!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isScan: Bool = false
    var isRecord: Bool = false
    var isFromHistory: Bool = false
    var selectedWeightUnit = "kg"
    var selectedHeighUnit = "cm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }
    
    func setupUI(){
        
        btnContinue.makeButtonDeactive()
        if isScan{
            txtTitle.text = "Scan"
        }else if isRecord{
            txtTitle.text = "Record"
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        // If user is opening the weight screen from history -> report. Then navigate back to Home.
        if isFromHistory{
            AppDelegate.app.moveToDashboard()
        }else{
            self.navigateBack()
        }
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        
        if isScan{
            let vc = ScanFirstVC.initFrom(storyboard: .captures)
            pushViewController(vc: vc)
        } else if isRecord{
            var weight = inputWeight.text
            var height = inputHeight.text
            
            if selectedWeightUnit == "lb"{
                weight = inputWeight.text?.convertLbToKg()
            }
            if selectedHeighUnit == "ft"{
                height = inputHeight.text?.convertFtToCm()
            }
            
            userDefault.saveValue(value: true as Any, key: UDKey.isRecordingWeightAdded)
            userDefault.saveValue(value: weight as Any, key: UDKey.videoWeight)
            userDefault.saveValue(value: height as Any, key: UDKey.videoHeight)
            
            let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
            vc.isRecord = true
            pushViewController(vc: vc)
        } else{
            self.navigateForward(storyBoard: SBRecordings, viewController: recordingPlayerTypeVCID)
        }
    }
    
    @IBAction func actionSelectHeightUnit(_ sender: Any) {
        self.inputWeight.resignFirstResponder()
        let alert = UIAlertController(title: "Select Unit", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "cm", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "cm"
            self.inputHeightUnit.text = "cm"
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "ft", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "ft"
            self.inputHeightUnit.text = "ft"
            self.dismiss(animated: true)
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
            self.txtWeightUnit.text = "kg"
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "lb", style: .default , handler:{ (UIAlertAction)in
            self.selectedWeightUnit = "lb"
            self.txtWeightUnit.text = "lb"
            self.dismiss(animated: true)
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

extension RecordingWeightVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(!self.inputWeight.text!.isEmpty) && (!self.inputHeight.text!.isEmpty){
            btnContinue.makeButtonActive()
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if !(self.inputWeight.text!.isEmpty) && !(self.inputHeight.text!.isEmpty){
            btnContinue.makeButtonActive()
        }else{
            btnContinue.makeButtonDeactive()
        }
    }
}
