//
//  ProfileVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 24/05/2022.
//

import UIKit

class ProfileVC: BaseVC {
    
    // MARK: OUTLETS
    @IBOutlet weak var inputRole: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPhoneNumber: UITextField!
    @IBOutlet weak var inputHandedness: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputStreet: UITextField!
    @IBOutlet weak var inputHouseNumber: UITextField!
    @IBOutlet weak var inputZipcode: UITextField!
    @IBOutlet weak var inputCountry: UITextField!
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var inputHeight: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    
    // MARK: VARIABLES
    var userDetails = UserDetails()
    var isProfileUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
    }
    
    
    private func getUserDetails(){
        GetUserRequest.shared.loggedUserId = Global.shared.loginUser?.userId.toString() ?? ""
        GetUserRequest.shared.userId = Global.shared.loginUser?.userId.toString() ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getUser, params: GetUserRequest.shared.returnGetUserRequestParams(), method: .post, type: "get", loading: true, headerType: .headerWithAuth)
    }
    
    private func setupUI(downloadImage: Bool = true){
        if downloadImage{
            imgProfile.downloadImage(imageUrl: userDetails.picture, placeHolder: "smProfile")
        }
        
        inputName.text = (userDetails.firstName ?? "") + " " + (userDetails.lastName ?? "")
        inputPhoneNumber.text = userDetails.contactNumber
        inputEmail.text = userDetails.email
        inputRole.text = userDetails.role
        inputHandedness.text = userDetails.playerType
        inputStreet.text = userDetails.address
        inputHouseNumber.text = userDetails.houseNo
        inputZipcode.text = userDetails.postCode
        inputCountry.text = userDetails.country
        inputCity.text = userDetails.city
        
        inputWeight.text = (Global.shared.loginUser?.weight ?? "0") + " kg"
        inputHeight.text = (Global.shared.loginUser?.height ?? "0") + " cm"
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        let vc = EditProfileViewController.initFrom(storyboard: .dashboard)
        vc.delegate = self
        vc.userDetails = self.userDetails
        self.present(vc, animated: true)
    }
    
}

//MARK: Edit Profile
extension ProfileVC: EditProfileProtocol{
    
    func profileUpdated(user: UserDetails, profileImage: UIImage) {
        
        isProfileUpdated = true
        self.userDetails = user
        self.imgProfile.image = profileImage
        getUserDetails()
    }
}



//MARK: SERVER RESPONSE
extension ProfileVC: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "get"{
            self.userDetails = UserDetails(json: json)
            
            // Saving the user in User Defaults
            if let user  = Global.shared.loginUser{
                
                
                user.subscriptionExpiry = userDetails.subscriptionExpiry ?? ""
                user.subscriptionId = userDetails.subscriptionId ?? ""
                user.subscriptionName = userDetails.subscriptionName ?? ""
                user.isSubscriptionActive = userDetails.isSubscriptionActive
                user.isGuest = userDetails.isGuest
                user.picturePath = userDetails.picture ?? ""
                
                userDefault.saveUser(user: user)
                print("User Updated")
                
                self.setupUI()
            
            }
            
            
            
            
            setupUI(downloadImage: !isProfileUpdated)
        }
    }
}


