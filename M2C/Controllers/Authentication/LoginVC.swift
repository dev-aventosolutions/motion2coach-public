//
//  LoginVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import UIKit
import DTTextField

class LoginVC: BaseVC {
    //------------------------------------
    // MARK: IBOutlets
    //------------------------------------
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnRememberMe: CheckBox!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnPasswordUnhide: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtVersion: UILabel!
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    var isTncChecked: Bool = false
    
    //------------------------------------
    // MARK: Overriden Functions
    //------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        AppDelegate.app.checkRememberUser()
        
        #if DEBUG
        self.txtUserName.text = "muhammad.ahsan@fenrispakistan.com"
        self.txtPassword.text = "Testing123"
        self.btnLogin.makeButtonActive()
        #endif
    }
    
    private func setupUI(){
        btnLogin.makeButtonDeactive()
        txtUserName.text = Global.shared.loginUser?.email
        txtPassword.text = ""
        txtVersion.text = "V " + (Bundle.main.releaseVersionNumber ?? "") + "(" + (Bundle.main.buildVersionNumber ?? "") + ")"
    }
    
    //------------------------------------
    // MARK: IBActions
    //------------------------------------
    @IBAction func actionForgetPassword(_ sender: Any) {
        self.navigateForward(storyBoard: SBMain, viewController: ForgetPasswordVCID)
    }
    
    @IBAction func actionViewPassword(_ sender: Any) {
        if(self.txtPassword.isSecureTextEntry){
            self.btnPasswordUnhide.setImage(UIImage(named: "eyeOpen"), for: .normal)
            self.txtPassword.isSecureTextEntry = false
        }
        else{
            self.btnPasswordUnhide.setImage(UIImage(named: "eyeClosed"), for: .normal)
            self.txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: DTTextField) {
        if txtUserName.text!.isValid(.email) && !(txtPassword.text!.isEmpty){
            btnLogin.makeButtonActive()
        }else{
            btnLogin.makeButtonDeactive()
        }
    }
    
    @IBAction func btnRememberMeClicked(_ sender: Any) {
        isTncChecked = !isTncChecked
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        if(self.validate()){
            self.showIndicator(withTitle: "Logging In...")
            let params = ["username" : self.txtUserName.text!,
                          "password" : self.txtPassword.text!,
                          "deviceId": getUUID(),
                          "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
                          "deviceType": "iOS"]
            
            ServiceManager.shared.loginCall(parameters: params, success: { response in
                self.hideIndicator()
                if let data = response as? NSDictionary{
                    
                    var loginUser = LoginUser(json: JSON(data))
                    loginUser = LoginUser(userId: loginUser.userId, firstName: loginUser.firstName, lastName: loginUser.lastName, roleId: loginUser.roleId, picturePath: loginUser.picturePath, createdOn: loginUser.createdOn, sessionToken: loginUser.sessionToken, active: loginUser.active, roleName: loginUser.roleName, email: self.txtUserName.text ?? "", playerTypeId: loginUser.playerTypeId, isGuest: loginUser.isGuest, subscriptionExpiry: loginUser.subscriptionExpiry, subscriptionId: loginUser.subscriptionId, subscriptionName: loginUser.subscriptionName, isSubscriptionActive: loginUser.isSubscriptionActive, weight: "", height: "")
                    
                    Global.shared.loginUser = loginUser
                    
                    if self.isTncChecked{
                        //To save the object
                        do {

                            let encodedUser = try NSKeyedArchiver.archivedData(withRootObject: loginUser, requiringSecureCoding: true)
                            userDefault.set(encodedUser, forKey: UDKey.savedUser)
                            userDefault.synchronize()
                        } catch {
                            
                        }
                        
                    }
                    AppDelegate.app.moveToDashboard()
                    
                }
                
            }, failure: { response in
                self.hideIndicator()
                if let json = response as? JSON{
                    
                    let msg = json["message"].stringValue
                    
                    // For Account Activation Case
                    if msg == "Account Activation Required"{
                        self.showActivateUserPopup(email: self.txtUserName.text ?? "", onSendOtp: {
                            let vc = OtpVerificationVC.initFrom(storyboard: .auth)
                            vc.email = self.txtUserName.text
                            vc.isFromLogin = true
                            self.pushViewController(vc: vc)
                        })
                        self.showPopupAlert(title: "Error", message: msg, btnOkTitle: "Ok")
                    }
                    else{
                        self.showPopupAlert(title: "Error", message: msg, btnOkTitle: "Ok")
                    }
                    
                }
                
            })
            
        }
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        
        let vc = SignUpProfileViewController.initFrom(storyboard: .auth)
        pushViewController(vc: vc)
    }
    @IBAction func actionGoBack(_ sender: Any) {
        self.navigateBack()
    }
    
    func validate() -> Bool{
        var message = ""
        var isValid = true
        if(self.txtUserName.text?.isEmpty ?? true){
            message = "Username is required"
            isValid = false
        }
        else if(self.txtPassword.text?.isEmpty ?? true){
            message = "Password is required"
            isValid = false
        }
        if(!isValid){
            self.alertWarning(title: "Oops", message: message)
        }
        //pop here message
        return isValid
    }
}
