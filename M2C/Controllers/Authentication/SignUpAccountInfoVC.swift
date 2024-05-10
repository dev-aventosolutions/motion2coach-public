//
//  SignUpAccountInfoVC.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/07/2022.
//

import UIKit

class SignUpAccountInfoVC: BaseVC {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputReEnterPassword: UITextField!
    @IBOutlet weak var imgCondition1: UIImageView!
    @IBOutlet weak var imgCondition2: UIImageView!
    @IBOutlet weak var imgCondition3: UIImageView!
    
    @IBOutlet weak var txtCondition1: UILabel!
    @IBOutlet weak var txtCondition2: UILabel!
    @IBOutlet weak var txtCondition3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        self.addAsterikesToFields()
        btnNext.makeButtonDeactive()
    }
    
    func addAsterikesToFields() {
        self.addRedAsterik(textField: inputEmail)
        self.addRedAsterik(textField: inputPassword)
        self.addRedAsterik(textField: inputReEnterPassword)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        SignUpRequest.shared.email = inputEmail.text ?? ""
        SignUpRequest.shared.password = inputPassword.text ?? ""
        
        let params: [String: Any] = ["email": inputEmail.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.checkEmail, params: params, method: .post, type: "email_check", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        popViewController()
    }
    
    @IBAction func eyePassClicked(_ sender: UIButton) {
        inputPassword.isSecureTextEntry = !inputPassword.isSecureTextEntry
        inputPassword.isSecureTextEntry ? sender.setImage(UIImage(named: "eyeClosed"), for: .normal) : sender.setImage(UIImage(named: "eyeOpen"), for: .normal)
    }
    
    @IBAction func eyeConfirmPassClicked(_ sender: UIButton) {
        inputReEnterPassword.isSecureTextEntry = !inputReEnterPassword.isSecureTextEntry
        inputReEnterPassword.isSecureTextEntry ? sender.setImage(UIImage(named: "eyeClosed"), for: .normal) : sender.setImage(UIImage(named: "eyeOpen"), for: .normal)
    }
}

//MARK: TextField Methods
extension SignUpAccountInfoVC{
    @IBAction func textFieldDidChange(_ sender: Any) {
        
        // For condition 1: At least 6 characters
        if (inputPassword.text!.count >= 6){
            imgCondition1.show()
            txtCondition1.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition1.hide()
            txtCondition1.textColor = .fenrisGrey
            btnNext.makeButtonDeactive()
        }
        
        // For condition 2: Contains lower and upper case letters
        if (inputPassword.text!.isValid(.containsOneUpperCase) && inputPassword.text!.isValid(.containsOnelowerCase)){
            imgCondition2.show()
            txtCondition2.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition2.hide()
            txtCondition2.textColor = .fenrisGrey
            btnNext.makeButtonDeactive()
        }
        
        // For condition 3: Contains one number
        if (inputPassword.text!.isValid(.containsOneNumber)){
            imgCondition3.show()
            txtCondition3.textColor = .fenrisBlue
            validateFields()
        }else{
            imgCondition3.hide()
            txtCondition3.textColor = .fenrisGrey
            btnNext.makeButtonDeactive()
        }
    }
    
    func validateFields(){
        if (inputPassword.text == inputReEnterPassword.text) && !(imgCondition1.isHidden) && !(imgCondition2.isHidden) && !(imgCondition3.isHidden){
            if inputPassword.text!.isEmpty || inputPassword.text!.isEmpty || inputPassword.text!.isEmpty{
                btnNext.makeButtonDeactive()
            }else{
                if inputEmail.text!.isValid(.email){
                    btnNext.makeButtonActive()
                }else{
                    btnNext.makeButtonDeactive()
                }
            }
        }else{
            btnNext.makeButtonDeactive()
        }
    }
}

//MARK: Server Response
extension SignUpAccountInfoVC: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        if val == "email_check"{
            
            let emailCheck: CheckEmail = CheckEmail(json: json)
            
            if (emailCheck.active == nil) && (emailCheck.userName == nil){
                let vc = UploadProfilePictureVC.initFrom(storyboard: .auth)
                pushViewController(vc: vc)
            }else{
                self.showPopupAlert(title: "Error", message: "Email already exists", btnOkTitle: "Ok")
            }
            
        }
    }
    
}
