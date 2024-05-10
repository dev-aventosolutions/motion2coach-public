//
//  ConnectStrikerViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/12/2022.
//

import UIKit

class ConnectStrikerViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var btnSendInvite: UIButton!
    @IBOutlet weak var inputEmail: UITextField!
    
    //MARK: VARIABLES
    
    
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSendInvite.makeButtonDeactive()
    }
    
    func sendInvite(){
        
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId": Global.shared.loginUser?.roleId as Any,
                                     "coachEmail" : inputEmail.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.inviteUser, params: params, method: .post, type: "invite", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnSendInviteClicked(_ sender: Any) {
        sendInvite()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
    }
    
    @IBAction func inputEmailChanged(_ sender: Any) {
        if !(inputEmail.text!.isEmpty) && (inputEmail.text!.isValid(.email)){
            btnSendInvite.makeButtonActive()
        }else{
            btnSendInvite.makeButtonDeactive()
        }
    }

}

extension ConnectStrikerViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        if val == "invite"{
            let popupVC = SuccessViewController.initFrom(storyboard: .general)
            popupVC.alertMessage = "Request Sent Successfully"
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                popupVC.removeAnimate()
                self.popViewController()
            }
        }
    }
}
