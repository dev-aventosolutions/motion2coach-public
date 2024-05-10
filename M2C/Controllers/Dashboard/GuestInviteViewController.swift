//
//  GuestInviteViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/01/2023.
//

import UIKit

class GuestInviteViewController: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputGender: UITextField!
    @IBOutlet weak var inputHandedness: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var btnSendInvite: UIButton!
    
    // MARK: VARIABLES
    var email: String = ""
    var selectedGender: Gender?
    var selectedPlayerType: PlayerType?
    var arrGenders = [Gender]()
    var arrPlayerTypes = [PlayerType]()
    var pickerViewGenders = UIPickerView()
    private var genderPickerIndex:Int = 0
    var pickerViewPlayerType = UIPickerView()
    private var playerTypePickerIndex:Int = 0
    
    // MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getGenders()
        getPlayerTypes()
    }
    
    // MARK: HELPERS
    func setupUI(){
        self.pickerViewGenders.delegate = self
        self.pickerViewGenders.dataSource = self
        self.pickerViewPlayerType.delegate = self
        self.pickerViewPlayerType.dataSource = self
        self.inputGender.inputView = pickerViewGenders
        self.inputHandedness.inputView = pickerViewPlayerType
        self.inputGender.delegate = self
        self.inputHandedness.delegate = self
        self.inputEmail.delegate = self
        self.inputFirstName.delegate = self
        self.inputLastName.delegate = self
        
        self.inputEmail.text = email
        self.inputFirstName.addRedAsterik()
        self.inputLastName.addRedAsterik()
//        self.inputGender.addRedAsterik()
        self.inputHandedness.addRedAsterik()
        self.inputEmail.addRedAsterik()
        self.btnSendInvite.makeButtonDeactive()
    }
    
    private func getGenders(){
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getGenders, method: .get, type: "genders", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getPlayerTypes(){
        
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getPlayerTypes, method: .get, type: "player_types", loading: false, headerType: .headerWithoutAuth)
    }
    
    // MARK: ACTIONS
    @IBAction func btnSendInviteClicked(_ sender: Any) {
        InviteGuestRequest.shared.firstName = self.inputFirstName.text ?? ""
        InviteGuestRequest.shared.lastName = self.inputLastName.text ?? ""
        InviteGuestRequest.shared.genderId = self.selectedGender?.id ?? "4"
        InviteGuestRequest.shared.playerType = self.selectedPlayerType?.id ?? ""
        InviteGuestRequest.shared.email = inputEmail.text ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.inviteGuest, params: InviteGuestRequest.shared.returnInviteGuestRequest(), method: .post, type: "invite_guest", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
    }
    
    @IBAction func textFieldEndEditing(_ sender: Any) {
        validateTextFields()
        
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        validateTextFields()
    }
    
    
    
    func validateTextFields(){
//        || inputGender.text!.isEmpty
        if inputFirstName.text!.isEmpty || inputLastName.text!.isEmpty || inputHandedness.text!.isEmpty || inputEmail.text!.isEmpty  {
            // If textfields are empty
            self.btnSendInvite.makeButtonDeactive()
        } else {
            self.btnSendInvite.makeButtonActive()
        }
    }
    
    
}

// MARK: TextField Methods
extension GuestInviteViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == inputGender {
            inputGender.text = arrGenders[genderPickerIndex].name
            selectedGender = arrGenders[genderPickerIndex]
        }else if textField == inputHandedness {
            if !arrPlayerTypes.isEmpty{
                inputHandedness.text = arrPlayerTypes[playerTypePickerIndex].name
                selectedPlayerType = arrPlayerTypes[playerTypePickerIndex]
            }
        }
        
        validateTextFields()
        resignFirstResponder()
    }
}

// MARK: Picker View Methods
extension GuestInviteViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewGenders{
            return arrGenders.count
        }else if pickerView == pickerViewPlayerType{
            return arrPlayerTypes.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewGenders{
            return arrGenders[row].name
        }else if pickerView == pickerViewPlayerType{
            return arrPlayerTypes[row].name
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewGenders{
            self.genderPickerIndex = row
            self.selectedGender = arrGenders[row]
            
        }else if pickerView == pickerViewPlayerType{
            self.playerTypePickerIndex = row
            self.inputHandedness.text = arrPlayerTypes[row].name
            
        }else{
            print("")
        }
        
    }
}


// MARK: SERVER RESPONSE
extension GuestInviteViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "invite_guest"{
            
            let vc = InviteSentViewController.initFrom(storyboard: .dashboard)
            self.pushViewController(vc: vc)
            
        }else if val == "genders"{
            
            arrGenders.removeAll()
            let gendersJsonArray = json.arrayValue
            gendersJsonArray.forEach({ arrGenders.append(Gender(json: $0)) })
            pickerViewGenders.reloadInputViews()
            inputGender.isUserInteractionEnabled = true
            
        }else if val == "player_types"{
            
            arrPlayerTypes.removeAll()
            let playerTypesJsonArray = json.arrayValue
            playerTypesJsonArray.forEach({ arrPlayerTypes.append(PlayerType(json: $0)) })
            inputHandedness.isUserInteractionEnabled = true
        }
    }
    
    func onFailure(json: JSON?, val: String) {
        
    }
}
