//
//  SignUpProfileViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/07/2022.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpProfileViewController: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputDateOfBirth: UITextField!
    @IBOutlet weak var inputGender: UITextField!
    @IBOutlet weak var inputRole: UITextField!
    @IBOutlet weak var inputUnit: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var inputHand: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    //MARK: VARIABLES
    //    var roleList: RoleList?
    var selectedGender: Gender?
    var selectedRole: Role?
    var selectedPlayerType: PlayerType?
    var arrGenders = [Gender]()
    var arrRoles = [Role]()
    var arrPlayerTypes = [PlayerType]()
    var arrCountries = [Country]()
    var pickerViewRoles = UIPickerView()
    private var rolePickerIndex:Int = 0
    var pickerViewGenders = UIPickerView()
    private var genderPickerIndex:Int = 0
    var pickerViewWeightUnit = UIPickerView()
    private var weightPickerIndex:Int = 0
    var pickerViewHand = UIPickerView()
    private var handPickerIndex:Int = 0
    var datePicker : UIDatePicker = UIDatePicker()
    
    //MARK: OVERRIDDEN METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        getRoles()
//        getGenders()
//        getPlayerTypes()
        getMasterData()
        inputRole.isUserInteractionEnabled = false
        inputGender.isUserInteractionEnabled = false
        inputHand.isUserInteractionEnabled = false
    }
    
    private func setupUI(){
        btnNext.makeButtonDeactive()
        inputGender.inputView = pickerViewGenders
        inputRole.inputView = pickerViewRoles
        inputUnit.inputView = pickerViewWeightUnit
        inputHand.inputView = pickerViewHand
        inputGender.delegate = self
        inputRole.delegate = self
        inputUnit.delegate = self
        inputHand.delegate = self
        inputDateOfBirth.delegate = self
        pickerViewRoles.delegate = self
        pickerViewGenders.delegate = self
        pickerViewWeightUnit.delegate = self
        pickerViewHand.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.locale = .current
        datePicker.maximumDate = NSDate() as Date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
        inputDateOfBirth.inputView = datePicker
        self.addAsteriksToField()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
    }
    
    func addAsteriksToField(){
        self.addRedAsterik(textField: self.inputFirstName)
        self.addRedAsterik(textField: self.inputLastName)
//        self.addRedAsterik(textField: self.inputDateOfBirth)
//        self.addRedAsterik(textField: self.inputGender)
        self.addRedAsterik(textField: self.inputRole)
        self.addRedAsterik(textField: self.inputUnit)
        self.addRedAsterik(textField: self.inputWeight)
        self.addRedAsterik(textField: self.inputHand)
       
    }
    
    private func getRoles(){
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getRoles, method: .get, type: "roles", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getGenders(){
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getGenders, method: .get, type: "genders", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getPlayerTypes(){
        
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getPlayerTypes, method: .get, type: "player_types", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getMasterData(){
        
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getMasterData, method: .get, type: "master_data", loading: false, headerType: .headerWithoutAuth)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        
        SignUpRequest.shared.firstName = inputFirstName.text ?? ""
        SignUpRequest.shared.lastName = inputLastName.text ?? ""
        SignUpRequest.shared.dateOfBirth = inputDateOfBirth.text ?? ""
        SignUpRequest.shared.genderId = selectedGender?.id ?? "4"
        SignUpRequest.shared.role = selectedRole?.id ?? ""
        SignUpRequest.shared.playerType = selectedPlayerType?.id ?? ""
        
        let vc = SignUpAddressVC.initFrom(storyboard: .auth)
        vc.arrCountries = arrCountries
        pushViewController(vc: vc)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        popViewController()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        inputDateOfBirth.text = sender.date.toDateString(format: DateFormats.DateFormatStandard2)
    }
    
    
}

// MARK: TextField Methods
extension SignUpProfileViewController: UITextFieldDelegate{
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        
        self.validateTextFields()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.shared.reloadLayoutIfNeeded()
        
        if textField == inputRole{
            inputRole.text = arrRoles[rolePickerIndex].roleName
            selectedRole = arrRoles[rolePickerIndex]
        }else if textField == inputGender {
            inputGender.text = arrGenders[genderPickerIndex].name
            selectedGender = arrGenders[genderPickerIndex]
        }else if textField == inputWeight {
            inputWeight.text = AppConstants.arrUnits[weightPickerIndex]
        }else if textField == inputHand {
            if !arrPlayerTypes.isEmpty{
                inputHand.text = arrPlayerTypes[handPickerIndex].name
                selectedPlayerType = arrPlayerTypes[handPickerIndex]
            }
        }
        
        IQKeyboardManager.shared.reloadInputViews()
        resignFirstResponder()
        validateTextFields()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputDateOfBirth{
            inputDateOfBirth.text = datePicker.date.toDateString(format: DateFormats.DateFormatStandard2)
        }
    }
    
    fileprivate func validateTextFields(){
        inputWeight.inputNumbersOnly()
        
//        inputDateOfBirth.text!.isEmpty || inputGender.text!.isEmpty ||
        
        if inputFirstName.text!.isEmpty || inputLastName.text!.isEmpty ||  inputRole.text!.isEmpty || inputHand.text!.isEmpty {
            // If textfields are empty
            btnNext.makeButtonDeactive()
        } else {
            // Checking validation
            if inputFirstName.text!.isValid(.name) && inputLastName.text!.isValid(.name) {
                btnNext.makeButtonActive()
            }else{
                // If any textfield is invalid
                btnNext.makeButtonDeactive()
            }
        }
    }
}

// MARK: Picker View Delegate
extension SignUpProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewRoles{
            return arrRoles.count
        }else if pickerView == pickerViewGenders{
            return arrGenders.count
        }else if pickerView == pickerViewWeightUnit{
            return AppConstants.arrUnits.count
        }else if pickerView == pickerViewHand{
            return arrPlayerTypes.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewRoles{
            return arrRoles[row].roleName
            
        }else if pickerView == pickerViewGenders{
            return arrGenders[row].name
    
        }else if pickerView == pickerViewWeightUnit{
            return AppConstants.arrUnits[row]
            
        }else if pickerView == pickerViewHand{
            return arrPlayerTypes[row].name
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewRoles{
            rolePickerIndex = row
            selectedRole = arrRoles[row]
            inputRole.text = arrRoles[row].roleName
            
        }else if pickerView == pickerViewGenders{
            genderPickerIndex = row
            selectedGender = arrGenders[row]
            
        }else if pickerView == pickerViewWeightUnit{
            weightPickerIndex = row
            
        }else if pickerView == pickerViewHand{
            handPickerIndex = row
            inputHand.text = arrPlayerTypes[row].name
            
        }else{
            print("")
        }
    }
    
}

// MARK: API Calls
extension SignUpProfileViewController: ServerResponse{
    func onSuccess(json: JSON, val: String) {
        if val == "roles"{
            arrRoles.removeAll()
            let rolesJsonArray = json.arrayValue
            rolesJsonArray.forEach({ arrRoles.append(Role(json: $0)) })
            pickerViewRoles.reloadInputViews()
            inputRole.isUserInteractionEnabled = true
        }else if val == "genders"{
            arrGenders.removeAll()
            let gendersJsonArray = json.arrayValue
            gendersJsonArray.forEach({ arrGenders.append(Gender(json: $0)) })
            pickerViewGenders.reloadInputViews()
            inputGender.isUserInteractionEnabled = true
        }else if val == "player_types"{
            let playerTypesJsonArray = json.arrayValue
            for each in playerTypesJsonArray{
                let temp : PlayerType = PlayerType(json: each)
                arrPlayerTypes.append(temp)
                
            }
            inputHand.isUserInteractionEnabled = true
        }
        
        else if val == "master_data"{

            // For Genders
            arrGenders.removeAll()
            let gendersJsonArray = json["genders"].arrayValue
            gendersJsonArray.forEach({ arrGenders.append(Gender(json: $0)) })
            pickerViewGenders.reloadInputViews()
            inputGender.isUserInteractionEnabled = true
            
            // For Player Types
            arrPlayerTypes.removeAll()
            let playerTypesJsonArray = json["playerTypes"].arrayValue
            playerTypesJsonArray.forEach({ arrPlayerTypes.append(PlayerType(json: $0)) })
            inputHand.isUserInteractionEnabled = true
            
            // For Countries
            arrCountries.removeAll()
            let countriesJsonArray = json["countries"].arrayValue
            countriesJsonArray.forEach({ arrCountries.append(Country(json: $0)) })
            
            // For roles
            arrRoles.removeAll()
            let rolesJsonArray = json["roles"].arrayValue
            rolesJsonArray.forEach { roleJson in
                let tempRole = Role(json: roleJson)
                if tempRole.roleName == "Striker" || tempRole.roleName == "Coach"{
                    arrRoles.append(tempRole)
                }
            }
            pickerViewRoles.reloadInputViews()
            inputRole.isUserInteractionEnabled = true
            
        }
    }
}
