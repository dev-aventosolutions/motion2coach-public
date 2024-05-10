//
//  ViewController.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import UIKit
import GoogleSignIn

class LandingVC: BaseVC {
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    
    
    //------------------------------------
    // MARK: Overriden Funstions
    //------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigateForward(storyBoard: SBCaptures, viewController: liveVCID)
    }
    
    //------------------------------------
    // MARK: IBActions
    //------------------------------------
    @IBAction func actionSignInWithApple(_ sender: Any) {
        
        
    }
    @IBAction func actionSignInWithGoogle(_ sender: Any) {
        //        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
        //            guard error == nil else { return }
        //            userDefaults.setValue(true, forKey: isSignedInWithGoogle)
        //            userDefaults.setValue(false, forKey: isSignedInWithApple)
        //            userDefaults.setValue(true, forKey: isUserLogin)
        //            self.navigateForward(storyBoard: SBMain, viewController: loginVCID)
        //        }
        
    }
    @IBAction func actionSignInWithEmail(_ sender: Any) {
        self.navigateForward(storyBoard: SBMain, viewController: loginVCID)
    }
    
    @IBAction func actionSkipSignUp(_ sender: Any) {
    }
    @IBAction func actionAlreadyHaveAnAccount(_ sender: Any) {
        self.navigateForward(storyBoard: SBMain, viewController: loginVCID)
        
    }
    
    @IBAction func actionTermsOfServices(_ sender: Any) {
        self.navigateForward(storyBoard: SBMain, viewController: termsOfServicesVCID)
        
    }
    
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        self.navigateForward(storyBoard: SBMain, viewController: privacyPolicyVCID)
        
    }
}
//------------------------------------
// MARK: Extensions
//------------------------------------

