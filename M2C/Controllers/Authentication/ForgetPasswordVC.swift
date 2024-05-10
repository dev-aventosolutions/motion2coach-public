//
//  ForgetPasswordVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 05/06/2022.
//

import UIKit
import DTTextField

class ForgetPasswordVC: BaseVC {

    @IBOutlet weak var txtEmailId: DTTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSubmit.makeButtonDeactive()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    @IBAction func actionSubmit(_ sender: Any) {
        let params: [String: Any] = ["email": txtEmailId.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.resetter, params: params, method: .post, type: "", loading: true, headerType: .headerWithAuth)
    }
    
    func validateTextFields(){
        if txtEmailId.text!.isValidEmail {
            // If textfields are empty
            self.btnSubmit.makeButtonActive()
        } else {
            self.btnSubmit.makeButtonDeactive()
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: DTTextField) {
        self.validateTextFields()
    }
}

extension ForgetPasswordVC: ServerResponse{
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        let passResetVC = PassResetViewController.initFrom(storyboard: .auth)
        passResetVC.modalPresentationStyle = .overCurrentContext
        self.present(passResetVC, animated: false, completion: nil)
        
    }
}
