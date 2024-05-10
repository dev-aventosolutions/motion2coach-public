//
//  SettingsAndPrivacyViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/08/2022.
//

import UIKit

class SettingsAndPrivacyViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var switchSyncWithCloud: UISwitch!
    @IBOutlet weak var inputCurrentPassword: UITextField!
    @IBOutlet weak var inputNewPassword: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var inputConfirmNewPassword: UITextField!
    @IBOutlet weak var imgCondition1: UIImageView!
    @IBOutlet weak var imgCondition2: UIImageView!
    @IBOutlet weak var imgCondition3: UIImageView!
    
    @IBOutlet weak var txtCondition1: UILabel!
    @IBOutlet weak var txtCondition2: UILabel!
    @IBOutlet weak var txtCondition3: UILabel!
    @IBOutlet weak var imgShowCurrentPassword: UIImageView!
    @IBOutlet weak var imgShowNewPassword: UIImageView!
    @IBOutlet weak var imgShowConfirmNewPassword: UIImageView!
    
    
    //MARK: VARIABLES
    
    
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: HELPERS
    private func setupUI(){
        self.hideNavigationBar()
        btnSave.makeButtonDeactive()
    }

    //MARK: ACTIONS
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        ChangePasswordRequest.shared.loggedUserId = Global.shared.loginUser?.userId ?? ""
        ChangePasswordRequest.shared.oldPassword = inputCurrentPassword.text ?? ""
        ChangePasswordRequest.shared.newPassword = inputNewPassword.text ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.changePassword, params: ChangePasswordRequest.shared.returnChangePasswordRequestParams(), method: .post, type: "change_password", loading: true, headerType: .headerWithAuth)
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @available(iOS 13.0, *)
    @IBAction func btnShowCurrentPassword(_ sender: Any) {
        if(self.inputCurrentPassword.isSecureTextEntry){
            self.imgShowCurrentPassword.image = UIImage(named: "eyeOpen")
            self.inputCurrentPassword.isSecureTextEntry = false
        } else{
            self.imgShowCurrentPassword.image = UIImage(named: "eyeClosed")
            self.inputCurrentPassword.isSecureTextEntry = true
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func btnShowNewPassword(_ sender: Any) {
        if(self.inputNewPassword.isSecureTextEntry){
            self.imgShowNewPassword.image = UIImage(named: "eyeOpen")
            self.inputNewPassword.isSecureTextEntry = false
        } else{
            self.imgShowNewPassword.image = UIImage(named: "eyeClosed")
            self.inputNewPassword.isSecureTextEntry = true
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func btnShowConfirmNewPassword(_ sender: Any) {
        if(self.inputConfirmNewPassword.isSecureTextEntry){
            self.imgShowConfirmNewPassword.image = UIImage(named: "eyeOpen")
            self.inputConfirmNewPassword.isSecureTextEntry = false
        } else{
            self.imgShowConfirmNewPassword.image = UIImage(named: "eyeClosed")
            self.inputConfirmNewPassword.isSecureTextEntry = true
        }
    }
    
}

extension SettingsAndPrivacyViewController: UITextFieldDelegate{
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        // For condition 1: At least 6 characters
        if (inputNewPassword.text!.count >= 6){
            imgCondition1.show()
            txtCondition1.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition1.hide()
            txtCondition1.textColor = .fenrisGrey
            btnSave.makeButtonDeactive()
        }
        
        // For condition 2: Contains lower and upper case letters
        if (inputNewPassword.text!.isValid(.containsOneUpperCase) && inputNewPassword.text!.isValid(.containsOnelowerCase)){
            imgCondition2.show()
            txtCondition2.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition2.hide()
            txtCondition2.textColor = .fenrisGrey
            btnSave.makeButtonDeactive()
        }
        
        // For condition 3: Contains one number
        if (inputNewPassword.text!.isValid(.containsOneNumber)){
            imgCondition3.show()
            txtCondition3.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition3.hide()
            txtCondition3.textColor = .fenrisGrey
            btnSave.makeButtonDeactive()
        }
        
    }
    
    func validateFields() {
        if !(inputCurrentPassword.text!.isEmpty) && !(inputNewPassword.text!.isEmpty) && !(inputConfirmNewPassword.text!.isEmpty) && (inputNewPassword.text == inputConfirmNewPassword.text) && !(imgCondition1.isHidden) && !(imgCondition2.isHidden) && !(imgCondition3.isHidden) {
            btnSave.makeButtonActive()
        }else{
            btnSave.makeButtonDeactive()
        }
    }
    
}

extension SettingsAndPrivacyViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "change_password"{
            let popupVC = SuccessViewController.initFrom(storyboard: .general)
            popupVC.alertMessage = "Password Changed Successfully"
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                popupVC.removeAnimate()
            }
        }
    }
}
