//
//  OtpVerificationVC.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/07/2022.
//

import UIKit

class OtpVerificationVC: BaseVC, UITextFieldDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var viewOtp: KAPinField!
    @IBOutlet weak var txtHeader: UILabel!
    @IBOutlet weak var txtSec: UILabel!
    @IBOutlet weak var inputOtp: UITextField!
    
    //MARK: VARIABLES
    var signUpUser: SignUpUser?
    var email: String?
    var isFromLogin: Bool = false
    var otpTimer: Timer? = nil
    var elapsedSeconds: Int = 60
    
    //MARK: OVERRIDDEN METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isFromLogin{
            getOtp()
        } else{
            startTimer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otpTimer?.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        otpTimer?.invalidate()
    }
    
    private func setupUI(){
        txtSec.text = ""
        self.addRedAsterik(textField: self.inputOtp)
        viewOtp.customisePinField()
        viewOtp.delegate = self
        print(signUpUser?.verificationToken)
        
        if email != nil{
            txtHeader.text = "Enter the 5 digit code sent to you at \(email ?? "")"
        }else{
            txtHeader.text = "Enter the 5 digit code sent to you at \(String(describing: SignUpRequest.shared.email))"
        }
        
    }
    
    private func startTimer(){
        otpTimer?.invalidate()
        elapsedSeconds = 60
        otpTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        txtSec.text = "This code is valid for \(elapsedSeconds) seconds"
        elapsedSeconds-=1
        
        if elapsedSeconds < 0{
            self.otpTimer?.invalidate()
        }
    }
    
    private func getOtp(){
        let params: [String: Any] = ["userName": self.email ?? "", "tokenFlag": "c"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.resendOtp, params: params, method: .post, type: "fromLogin", loading: true, headerType: .headerWithoutAuth)
    }

    @IBAction func btnNextClicked(_ sender: Any) {
        
        let params:[String:Any] = ["token" : inputOtp.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.activateUser, params: params, method: .post, type: "fromSignup", loading: true, headerType: .headerWithoutAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
//        popViewController()
        AppDelegate.app.moveToLogin()
    }
    
    @IBAction func btnResendOtp(_ sender: Any) {
        var email: String = ""
        if isFromLogin{
            email = self.email ?? ""
        } else{
            email = signUpUser?.userName ?? ""
        }
        
        let params: [String: Any] = ["userName": email, "tokenFlag": "c"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.resendOtp, params: params, method: .post, type: "resend", loading: true, headerType: .headerWithoutAuth)
    }
}

//MARK: SERVER RESPONSE
extension OtpVerificationVC: ServerResponse{
    func onSuccess(json: JSON, val: String) {
        
        if val == "fromSignup"{
            var loginUser = LoginUser(json: json)
            loginUser = LoginUser(userId: loginUser.userId, firstName: loginUser.firstName, lastName: loginUser.lastName, roleId: loginUser.roleId, picturePath: loginUser.picturePath, createdOn: loginUser.createdOn, sessionToken: loginUser.sessionToken, active: loginUser.active, roleName: loginUser.roleName, email: SignUpRequest.shared.email, playerTypeId: loginUser.playerTypeId, isGuest: loginUser.isGuest, subscriptionExpiry: loginUser.subscriptionExpiry, subscriptionId: loginUser.subscriptionId, subscriptionName: loginUser.subscriptionName, isSubscriptionActive: loginUser.isSubscriptionActive, weight: "", height: "")
            
            Global.shared.loginUser = loginUser
            
            let vc = CongratulationsViewController.initFrom(storyboard: .auth)
            self.pushViewController(vc: vc)
            
        } else if val == "fromLogin"{
            print(json)
            startTimer()
        }
        
    }
    
    func onSuccess(data: Data, val: String) {
        
    }
}
