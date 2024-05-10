//
//  DashbaordOptionsVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 14/06/2022.
//

import UIKit

class DashbaordOptionsVC: BaseVC {

    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var viewCapture: UIView!
    @IBOutlet weak var viewHistory: UIView!
    @IBOutlet weak var viewShotTracer: UIView!
    @IBOutlet weak var viewPositionGuide: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var viewStriker: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var txtStrikerName: UILabel!
    @IBOutlet weak var txtStrikerHandedness: UILabel!
    @IBOutlet weak var heightStrikerView: NSLayoutConstraint!
    @IBOutlet weak var viewSubscribe: UIView!
    @IBOutlet weak var imgSubscribe: UIImageView!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var txtDaysLeft: UILabel!
    
    
    var daysLeft: Int = 0
    var hoursLeft: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDaysLeft.text = ""
        print(getUUID())
        
        print("---")
        self.viewStriker.hide()
        self.heightStrikerView.constant = 0
        setupSideMenu()
        hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getUserDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("DID APPEAR")
    }
    
    private func getUserDetails(){
        GetUserRequest.shared.loggedUserId = Global.shared.loginUser?.userId.toString() ?? ""
        GetUserRequest.shared.userId = Global.shared.loginUser?.userId.toString() ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getUser, params: GetUserRequest.shared.returnGetUserRequestParams(), method: .post, type: "get_user_details", loading: true, headerType: .headerWithAuth)
    }
    
    func setupUI() {
        // If dashboard is for striker
        if let striker = Global.shared.selectedStriker {
            self.imgUser.downloadImage(imageUrl: striker.userpicture, placeHolder: "striker.placeholder")
            self.txtStrikerHandedness.text = striker.userPlayerType
            self.txtStrikerName.text = striker.userfirstName
            self.viewStriker.unhide()
            self.heightStrikerView.constant = 93
//            self.viewSideMenu.hide()
            self.disableSwipeBackFromLeftEdge()
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            if striker.userPlayerType.localizedStandardContains("right"){
                self.txtStrikerHandedness.text = "Right Handed"
            }else if striker.userPlayerType.localizedStandardContains("left"){
                self.txtStrikerHandedness.text = "Left Handed"
            }
            
        }else{
            self.viewStriker.hide()
            self.heightStrikerView.constant = 0
        }
        
        if let user = Global.shared.loginUser{
            
            if user.isGuest{
                // If the user is guest
                self.btnSubscribe.isUserInteractionEnabled = true
                self.imgSubscribe.image = UIImage(named: "guest.icon")
                self.txtDaysLeft.text = ""
            }else{
                // If subscription is active
                if user.isSubscriptionActive{
                    self.imgSubscribe.tintColor = .editPositionsYellowColor
                    
                    // If the subscription of user is Trial
                    if user.subscriptionId == "1"{
                        self.imgSubscribe.image = UIImage(named: "trial")
                        self.btnSubscribe.isUserInteractionEnabled = true
                    }else{
                        
                        self.imgSubscribe.image = UIImage(named: "premium")
                        if daysLeft > 1{
                            self.txtDaysLeft.text = "\(daysLeft) Days Left"
                            self.btnSubscribe.isUserInteractionEnabled = false
                        }else{
                            self.txtDaysLeft.text = "\(hoursLeft) Hours Left"
                            self.btnSubscribe.isUserInteractionEnabled = true
                        }
                        
                    }
                }else{
                    self.btnSubscribe.isUserInteractionEnabled = true
                    self.imgSubscribe.image = UIImage(named: "premium.ended")
                    self.txtDaysLeft.text = ""
                    let vc = GetPremiumViewController.initFrom(storyboard: .dashboard)
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func btnSubscribeClicked(_ sender: Any) {
        let vc = GetPremiumViewController.initFrom(storyboard: .dashboard)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    @IBAction func btnStrikerClicked(_ sender: Any) {
//        Global.shared.selectedStriker = nil
        if let viewControllers = self.navigationController?.viewControllers {
            
            if viewControllers.contains(where: {
                return $0 is StrikersListViewController
            }){
                print("VC is in the stack")
                //Write your code here
                self.popBackToStrikersList()
            }else{
                print("VC is not in the stack")
                let vc = StrikersListViewController.initFrom(storyboard: .dashboard)
                self.pushViewController(vc: vc)
            }
        }
    }
    
    @IBAction func actionHistory(_ sender: Any) {
       
        if let user = Global.shared.loginUser{
            
            // Guest can not view history
            if user.isGuest{
                
                let vc = GetPremiumViewController.initFrom(storyboard: .dashboard)
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
//                self.showPopupAlert(title: "Alert!", message: "Kindly subscribe to view history.")
            }else{
                // If subscription is active
                if user.isSubscriptionActive{
                    // only premium customers can view the history
                    let vc = RecordingHistoryVC.initFrom(storyboard: .recording)
                    vc.striker = Global.shared.selectedStriker
                    self.pushViewController(vc: vc)
                }else{
                    let vc = GetPremiumViewController.initFrom(storyboard: .dashboard)
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }
                
                
            }
        }
        
    }
    
    
    @IBAction func btnPracticeAreaClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func actionCapture(_ sender: Any) {
        
        if let user = Global.shared.loginUser{
            
            // Guest can not view history
            if user.isGuest{
//                self.showPopupAlert(title: "Alert!", message: "Kindly subscribe to view history.")
                
                // only premium customers can capture the swing
                let vc = CapturesOptionsVC.initFrom(storyboard: .captures)
                self.pushViewController(vc: vc)
                
            }else{
                // If subscription is active
                if user.isSubscriptionActive{
                    // only premium customers can capture the swing
                    let vc = CapturesOptionsVC.initFrom(storyboard: .captures)
                    self.pushViewController(vc: vc)
                }else{
                    let vc = GetPremiumViewController.initFrom(storyboard: .dashboard)
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }
            }
        }
        

    }

}

// MARK: SERVER RESPONSE
extension DashbaordOptionsVC: ServerResponse{

    func onSuccess(json: JSON, val: String) {
        print(json)

        if val == "get_user_details"{
            
            let userDetails = UserDetails(json: json)
            
            // Saving the user in User Defaults
            if let user  = Global.shared.loginUser{
                
                user.subscriptionExpiry = userDetails.subscriptionExpiry ?? ""
                user.subscriptionId = userDetails.subscriptionId ?? ""
                user.subscriptionName = userDetails.subscriptionName ?? ""
                user.isSubscriptionActive = userDetails.isSubscriptionActive
                user.isGuest = userDetails.isGuest
                user.email = userDetails.email ?? ""
                user.playerTypeId = userDetails.playerTypeId ?? "1"
                
                if #available(iOS 15, *) {
                    guard let expiryDate = user.subscriptionExpiry.dateFromISOString() else { return }
                    let todaysDate = Date.now
                    
                    let formatter = DateComponentsFormatter()
                    
                    let diff = expiryDate - todaysDate
                    var timeLeft: String = ""
                    
                    self.daysLeft = Int((diff/86400))
                    self.hoursLeft = Int((diff/3600))
                    if daysLeft > 1{
                        timeLeft = "\(daysLeft) Days Left"
                    }else{
                        timeLeft = "\(hoursLeft) Hours Left"
                    }
                    
                    self.txtDaysLeft.text = timeLeft
                } else {
                    // Fallback on earlier versions
                    
                }
                
                
                userDefault.saveUser(user: user)
                print("User Updated")
                
                
                self.setupUI()
            
            }
        }

    }

}
