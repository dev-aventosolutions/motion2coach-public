//
//  PassResetViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 03/11/2022.
//

import UIKit
import DTTextField

class PassResetViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var inputToken: DTTextField!
    @IBOutlet weak var inputPassword: DTTextField!
    
    @IBOutlet weak var inputConfirmPassword: DTTextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.backgroundColor = UIColor.white
        
        showAnimate()
        btnUpdate.makeButtonDeactive()
    }
    
    //MARK: ACTIONS
    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        let params: [String: Any] = ["token": inputToken.text ?? "", "newPassword": inputPassword.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.resetPass, params: params, method: .post, type: "", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        
        if !(inputToken.text!.isEmpty) && !(inputPassword.text!.isEmpty) && !(inputConfirmPassword.text!.isEmpty) && (inputPassword.text! == inputConfirmPassword.text!){
            btnUpdate.makeButtonActive()
        }else{
            btnUpdate.makeButtonDeactive()
        }
    }
    
}

//MARK: SERVER RESPONSE
extension PassResetViewController: ServerResponse{
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        let popupVC = SuccessViewController.initFrom(storyboard: .general)
        popupVC.alertMessage = "Password Changed Successfully"
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            popupVC.removeAnimate()
            AppDelegate.app.moveToLogin()
        }
        
    }
    
}
