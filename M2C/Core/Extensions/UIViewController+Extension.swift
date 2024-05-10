//
//  UIViewController+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit
import SideMenu
import Photos
import Starscream

extension UIViewController: StoryboardInitializable{
    
    func animateThing(thing: UIView, offsetX: CGFloat, offsetY: CGFloat, alpha: CGFloat, time: TimeInterval, delay: TimeInterval) {
        let targetY = thing.center.y
        let targetX = thing.center.x
        let targetAlpha = thing.alpha
        
        thing.center.y = thing.center.y - offsetY
        thing.center.x = thing.center.x - offsetX
        thing.alpha = thing.alpha - alpha
        
        
        UIView.animate(withDuration: time, delay: delay, options: .curveEaseOut, animations: { () -> Void in
            thing.center.y = targetY
            thing.center.x = targetX
            thing.alpha = targetAlpha
        }, completion: nil)
    }
    
    func redirectToLogin(currentVC: UIViewController){
        let vc = LoginVC.initFrom(storyboard: .auth)
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = vc
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
        } else {
            AppDelegate.app.window?.rootViewController = vc
            AppDelegate.app.window?.makeKeyAndVisible()
        }
    }
    
    func setupPrimaryNavBar(){
        // 1
        let nav = self.navigationController?.navigationBar
        
        // 2
        nav?.backgroundColor = .white
        nav?.tintColor = UIColor.black
        nav?.isHidden = false
        self.showNavigationBar()
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = title
        
    }
    
    func addLogoToNavigationBarItem(isHomeVC: Bool? = false,ispreLogin:Bool! = false) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "ic_logo")
        
        //imageView.backgroundColor = .lightGray
        
        // In order to center the title view image no matter what buttons there are, do not set the
        // image view as title view, because it doesn't work. If there is only one button, the image
        // will not be aligned. Instead, a content view is set as title view, then the image view is
        // added as child of the content view. Finally, using constraints the image view is aligned
        // inside its parent.
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.image = UIImage(named: "leftarrow")
        leftBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        leftBarButtonItem.action = #selector(barButtonAction)
        leftBarButtonItem.target = self
        
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        //        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "leftarrow")
        //        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "leftarrow")
        
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background_1"), for: .default)
        navigationController?.navigationBar.tintColor = .darkGray
    }
    
    func readLocalFile(forName fileName: String, fileType: FileType) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType.rawValue) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        
        return nil
    }
    
    // MARK: Left Bar Button Action
    @objc func barButtonAction() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation Bar methods
    /* Will show the navigation Bar */
    func showNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /* Will hide the navigation Bar */
    func hideNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /* Will hide the bottom Bar */
    func hideBottomBar(){
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = SideMenuNavigationController.initFrom(storyboard: .dashboard)
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
    }
    
    func saveVideosToPhotos(localURL: URL) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localURL)
        }, completionHandler: { (success: Bool, error: Error?) -> Void in
            // Must use Dispatch to display label text on main thread
            DispatchQueue.main.async {
                if success {
                    print("Video Saved In Gallery")
                } else {
                    print("Fail to Save Video: " + "\(String(describing: error?.localizedDescription))")
                }
            } // end Disptach
        })
    }
}


// MARK: Popup Alerts
extension UIViewController {
    
    func showPopupAlert(title : String, message : String, hideCross: Bool = false, btnOkTitle: String = "", btnCancelTitle: String = "", onOK: (() -> Void)? = nil, onCancel: (() -> Void)? = nil){
        
        let popupVC = PopupViewController.initFrom(storyboard: .general)
        popupVC.alertTitle = title
        popupVC.alertMessage = message
        popupVC.btnOkTitle = btnOkTitle
        popupVC.btnCancelTitle = btnCancelTitle
        popupVC.onOK = onOK
        popupVC.onCancel = onCancel
        popupVC.hideCross = hideCross
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
    }
    
    func showActivateUserPopup(email: String, onSendOtp: (() -> Void)? = nil){
        let popupVC = ActivateUserViewController.initFrom(storyboard: .auth)
        popupVC.onSendOtp = onSendOtp
        popupVC.email = email
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
    }
    
    func showGuestInvitePopup(onInviteGuest: (() -> Void)? = nil){
        let popupVC = GuestInvitePoupViewController.initFrom(storyboard: .dashboard)
        popupVC.onInviteGuest = onInviteGuest
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
    }
    
    func showVideoPreview(videoLink: URL, videoSettings: VideoRecordingSettings, onRetake: (() -> Void)? = nil, onViewSessions: (() -> Void)? = nil){
        let vc = RecordingPreviewViewController.initFrom(storyboard: .recording)
        vc.videoSettings = videoSettings
        vc.onRetake = onRetake
        vc.onViewSession = onViewSessions
        vc.videoLink = videoLink
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: SOCKETS
extension UIViewController{
    
//    func connectAndRequestSocket() {
//        var request = URLRequest(url: URL(string: "wss://w4v6un8ey8.execute-api.eu-west-1.amazonaws.com/production")!)
//        request.httpShouldUsePipelining = true
//        socket = WebSocket(request: request)
//        socket?.delegate = self
//        socket?.connect()
//    }
}

// MARK: Swipe gestures
extension UIViewController{
    
    /* Will enable swipe back gesture from anywhere in screen*/
    func enableSwipeAnywhereInView(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    /* Will enable swipe back gesture from left edgeof screen only */
    func enableSwipeBackFromLeftEdge(){
        let rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.rightSwipeAction))
        rightSwipe.edges = .left
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    /* Will disable swipe back gesture from left edge of screen only */
    func disableSwipeBackFromLeftEdge(){
        let rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.NoSwipeAction(_:)))
        rightSwipe.edges = .left
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func NoSwipeAction(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    @objc func rightSwipeAction(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleGesture(gesture : UISwipeGestureRecognizer) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func openSideMenuWithSwipeGesture(gesture : UISwipeGestureRecognizer) -> Void{
        
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                self.dismiss(animated: true)
            }
        });
    }
    
    // MARK: Notification
    func sendNotification(title:String,message:String!){
        // 1
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }
    
    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
    
    
    
    func addContainerView(_ viewController: UIViewController, view: UIView? = nil) {
        guard let targetView = view ?? viewController.view else { return }
        addChild(viewController)
        self.view.addSubview(targetView)
        viewController.didMove(toParent: self)
    }
}


extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return nil }
        return delegate
    }
    
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            return window
        }
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
        return window
    }
}

