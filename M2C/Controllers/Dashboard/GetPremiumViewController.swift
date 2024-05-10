//
//  GetPremiumViewController.swift
//  M2C
//
//  Created by Fenris GMBH on 13/02/2023.
//

import UIKit

class GetPremiumViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var imgPricing: UIImageView!
    @IBOutlet weak var txtDescription: UILabel!
    
    
    // MARK: VARIABLES
    var subscription: Subscription?
    
    
    // MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let desc = NSAttributedString(string: "By choosing M2C Premium, your PayPal account will be charged, and you will get your subscription. By choosing M2C Premium, you agree to our ")
        let terms = NSAttributedString(string: "Terms & Privacy Policy", attributes: [.foregroundColor: UIColor.fenrisBlue, .font: UIFont.boldSystemFont(ofSize: 13)])
        let textString = NSMutableAttributedString(string: "")
        textString.append(desc)
        textString.append(terms)
        txtDescription.attributedText = textString
        
        if Global.shared.loginUser?.roleName == "Coach"{
            self.imgPricing.image = UIImage(named: "pricing.coach")
        }else{
            self.imgPricing.image = UIImage(named: "pricing.striker")
        }
    }
    
    // MARK: ACTIONS
    @IBAction func btnGetPremiumClicked(_ sender: Any) {
        
//        if let subscription = self.subscription{
//            if let url = URL(string: subscription.url) {
//                UIApplication.shared.open(url)
//            }
//        }
        let id = Global.shared.loginUser?.userId ?? ""
        let params: [String: String] = ["loggedUserId": id, "userId": id]

        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getUserSubscription, params: params, method: .post, type: "get_user_subscription", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnCrossClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: SERVER RESPONSE
extension GetPremiumViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        if val == "get_user_subscription"{
            let subscription = Subscription(json: json)
            
            if subscription.url.isEmpty{
                self.showPopupAlert(title: "Error", message: "You are already subscribed or on trial version.")
            }else{
                if let url = URL(string: subscription.url) {
                    UIApplication.shared.open(url)
                }
            }
            
//            let vc = SubscriptionViewController.initFrom(storyboard: .dashboard)
//            vc.subscription = subscription
//            self.present(vc, animated: true)
            
        }
        
    }
    
}
