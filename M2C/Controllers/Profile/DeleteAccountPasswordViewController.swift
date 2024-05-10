//
//  DeleteAccountPasswordViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/01/2023.
//

import UIKit

class DeleteAccountPasswordViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    @IBOutlet weak var btnPasswordUnhide: UIButton!
    
    //MARK: VARIABLES
    
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    //MARK: HELPERS
    private func setupUI(){
        self.btnDeleteAccount.makeButtonDeactive()
    }
    
    private func deleteUser(){
        
        DeleteUserRequest.shared.password = inputPassword.text ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.deleteUser, params: DeleteUserRequest.shared.returnDeleteUserRequest(), method: .post, type: "delete_user", loading: true, headerType: .headerWithAuth)
    }
    
    //MARK: ACTIONS
    @IBAction func btnDeleteAcccountClicked(_ sender: Any) {
        
        self.deleteUser()
    }
    
    @IBAction func actionViewPassword(_ sender: Any) {
        if(self.inputPassword.isSecureTextEntry){
            self.btnPasswordUnhide.setImage(UIImage(named: "eyeOpen"), for: .normal)
            self.inputPassword.isSecureTextEntry = false
        }
        else{
            self.btnPasswordUnhide.setImage(UIImage(named: "eyeClosed"), for: .normal)
            self.inputPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func textfieldEditingChanged(_ sender: Any) {
        
        if inputPassword.text!.isEmpty{
            self.btnDeleteAccount.makeButtonDeactive()
        }else{
            self.btnDeleteAccount.makeButtonActive()
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
    }
}

//MARK: SERVER RESPONSE
extension DeleteAccountPasswordViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "delete_user"{
            
            userDefault.deleteValue(key: UDKey.savedUser)
            userDefault.deleteValue(key: UDKey.videoWeight)
            userDefault.deleteValue(key: UDKey.videoHeight)
            userDefault.deleteValue(key: UDKey.isRecordingWeightAdded)
            
            AppDelegate.app.moveToLogin()
        }
    }
}
