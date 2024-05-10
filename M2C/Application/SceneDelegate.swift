//
//  SceneDelegate.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Did Active")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let loginUser = Global.shared.loginUser{
            // Upon making the app in active state check getUser API. To get the status of subscription.
//            self.getUserDetails()
            
            
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    private func getUserDetails(){
        GetUserRequest.shared.loggedUserId = Global.shared.loginUser?.userId.toString() ?? ""
        GetUserRequest.shared.userId = Global.shared.loginUser?.userId.toString() ?? ""
        
        
        ServiceManager.shared.getUserProfile(parameters: GetUserRequest.shared.returnGetUserRequestParams(), success: { response in
            let userDetails = UserDetails(json: JSON(response))
            print(userDetails.subscriptionExpiry)
            
            // Saving the user in User Defaults
            if let user  = Global.shared.loginUser{
                user.subscriptionExpiry = userDetails.subscriptionExpiry ?? ""
                user.subscriptionId = userDetails.subscriptionId ?? ""
                user.subscriptionName = userDetails.subscriptionName ?? ""
                user.isSubscriptionActive = userDetails.isSubscriptionActive
                
                userDefault.saveUser(user: user)
                print("User Updated")
                
                if user.isSubscriptionActive{
                    
                    
                }else{
                    // If user has not subscribed then redirect to Dashboard
                    AppDelegate.app.moveToDashboard()
                }
            }
            
            
        }, failure: { response in
            print(response)
        })
        
        
    }

}
