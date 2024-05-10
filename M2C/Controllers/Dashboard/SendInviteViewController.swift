//
//  ConnectCoachUIViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/12/2022.
//

import UIKit

class SendInviteViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var btnSendInvite: UIButton!
    @IBOutlet weak var txtTitle: UILabel!
    
    //MARK: VARIABLES
    var mode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSendInvite.makeButtonDeactive()
        if mode == "Coach"{
            txtTitle.text = "Connect with Coach"
            txtDescription.text = "Enter details to send invite to the coach."
        }else{
            txtTitle.text = "Connect with Striker"
            txtDescription.text = "Enter details to send invite to the striker."
        }
    }
    
    func sendInvite(){
        
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId": Global.shared.loginUser?.roleId as Any,
                                     "userEmail" : inputEmail.text ?? ""]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.inviteUser, params: params, method: .post, type: "invite", loading: true, showErrorPrompt: false, headerType: .headerWithAuth)
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

//MARK: SERVER RESPONSE
extension SendInviteViewController: ServerResponse{
    
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
    
    func onFailure(json: JSON?, val: String) {
        print(json)
        
        let msg = json?["message"].stringValue
        // Only coach can invite a user as guest
        if Global.shared.loginUser?.roleName == "Coach"{
            
            if msg == "Striker does not exist in our system"{
                
                self.showGuestInvitePopup {
                    // On clicking Invite as Guest
                    let vc = GuestInviteViewController.initFrom(storyboard: .dashboard)
                    vc.email = self.inputEmail.text ?? ""
                    self.pushViewController(vc: vc)
                }
                
            } else{
                self.showPopupAlert(title: "Alert!", message: msg ?? "Something went wrong.")
            }
        } else{
            self.showPopupAlert(title: "Alert!", message: msg ?? "Something went wrong.")
        }
    }
}
