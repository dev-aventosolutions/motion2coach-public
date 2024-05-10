//
//  RecordingDOBVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 04/06/2022.
//

import UIKit

class RecordingDOBVC: BaseVC {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtDay: UITextField!
    
    var years = [Int]()
    var months = ["January", "February" , "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var days = [Int]()
    var isSelectingDay = false
    var isSelectingYear = false
    var isSelectingMonth = false
    var selectedRow = -1
     let pickerView = ToolbarPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        self.btnContinue.isEnabled = false
        
        self.btnContinue.backgroundColor = UIColor(hexString: "#978F91")
        
        
        self.addYears()
        self.addDays()
        self.txtMonth.inputView = self.pickerView
        self.txtDay.inputView = self.pickerView
        self.txtYear.inputView = self.pickerView
        self.txtYear.inputAccessoryView = self.pickerView.toolbar
        self.txtDay.inputAccessoryView = self.pickerView.toolbar
        self.txtMonth.inputAccessoryView = self.pickerView.toolbar
        self.pickerView.toolbarDelegate = self

       
    }
    
    func addYears(){
        self.years.removeAll()
        for year in 1960...Date().thisYear{
            self.years.insert(year, at: 0)
        }
    }
    
    func addDays(){
        self.days.removeAll()
        for day in 1...31{
            self.days.append(day)
        }
    }
    
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingGenderVCID)

    }
    
    @IBAction func actionYear(_ sender: Any) {
        self.isSelectingYear = true
        self.isSelectingMonth = false
        self.isSelectingDay = false
//        self.pickerView.reloadAllComponents()
        
//               self.pickerView.toolbarDelegate = self
        self.txtYear.becomeFirstResponder()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()

    }
    @IBAction func actionDay(_ sender: Any) {
        self.isSelectingYear = false
        self.isSelectingMonth = false
        self.isSelectingDay = true
        self.txtDay.becomeFirstResponder()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()
    }
    @IBAction func actionMonth(_ sender: Any) {
        self.isSelectingYear = false
        self.isSelectingMonth = true
        self.isSelectingDay = false
        self.txtYear.becomeFirstResponder()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()
    }
 
}


extension RecordingDOBVC : UIPickerViewDelegate , UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        self.selectedRow = 0
        if(self.isSelectingDay){
            return  self.days.count
        }
        else if(self.isSelectingYear){
            return  self.years.count
        }
        else if(self.isSelectingMonth){
            return self.months.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(self.isSelectingDay){
            return  String(describing: self.days[row])
        }
        else if(self.isSelectingYear){
            return  String(describing: self.years[row])
        }
        else if(self.isSelectingMonth){
            return self.months[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
       
    }

   
}

extension RecordingDOBVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        if(self.selectedRow != -1){
        if(self.isSelectingDay){
            self.txtDay.text = String(describing: self.days[self.selectedRow])
            self.isSelectingDay = false
        }
        else if(self.isSelectingYear){
            self.txtYear.text = String(describing: self.years[self.selectedRow])
            self.isSelectingYear = false
        }
        else if(self.isSelectingMonth){
            self.txtMonth.text = self.months[self.selectedRow]
            self.isSelectingMonth = false
        }
        }
        
        self.view.endEditing(true)
        self.selectedRow = -1
        if(self.txtDay.text != "Month" && self.txtYear.text != "Year" && self.txtMonth.text != "Day"){
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = UIColor(hexString: "#0069B4")
        }
    }

    func didTapCancel() {
        if(self.isSelectingDay){
            self.isSelectingDay = false
        }
        else if(self.isSelectingYear){
            self.isSelectingYear = false
        }
        else if(self.isSelectingMonth){
            self.isSelectingMonth = false
        }
        self.view.endEditing(true)
    }
}
