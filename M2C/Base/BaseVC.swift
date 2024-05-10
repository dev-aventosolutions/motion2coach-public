//
//  BaseVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import UIKit
import SPAlert
import SideMenu
import MBProgressHUD
import Photos
import AVKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //------------------------------------
    // MARK: Navigations
    //------------------------------------
    func navigateForward(storyBoard: String, viewController: String){
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(storyBoard: String, viewController: String){
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.present(vc, animated: true)
    }
    
    func navigateBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func popBackToSettings(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SettingsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToDashboard(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToDashboardOptions(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashbaordOptionsVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToStrikersList(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: StrikersListViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToRecordScreen(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: RecordingVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToOrientationScreen(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SelectOrientationViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popBackToLogin(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func getVC(storyBoard: String, viewController: String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: viewController)
        return vc
    }
    
    func deleteVideo(at url: String){
        PHPhotoLibrary.shared().performChanges( {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            
            let imageAssetToDelete = PHAsset.fetchAssets(with: fetchOptions)
            PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
        },
                                                completionHandler: { success, error in
            
        })
    }
    
    func export(_ asset: AVAsset, to outputMovieURL: URL) {
        //Create trim range
        //        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        //delete any old file
        do {
            try FileManager.default.removeItem(at: outputMovieURL)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
        //create exporter
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720)
        //configure exporter
        //    exporter?.videoComposition = AVVideoComposition()
        exporter?.outputURL = outputMovieURL
        exporter?.outputFileType = .mov
        exporter?.shouldOptimizeForNetworkUse = true
        //        exporter?.timeRange = timeRange
        //export!
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    print("failed \(error.localizedDescription)")
                } else {
                    //                    self.saveVideosToPhotos(localURL: outputMovieURL)
                    print("Video saved to \(outputMovieURL)")
                }
            }
        })
    }
    
    func trimAndExport(player: AVPlayer, outputPath: URL, asset: AVAsset, hittingTime: Double, _ callback: @escaping ((String) -> ())) {
        //Convert the duration of the video to seconds
        //    let videoDurationInSeconds = player.currentItem!.asset.duration.seconds
        let videoDurationInSeconds = asset.duration.seconds
        
        //Set the start time to 5 seconds.
        let startTime = CMTimeMakeWithSeconds((hittingTime - 3.0), preferredTimescale: 600)
        
        //Subtract 5 seconds from the end time
        let endTime = CMTimeMakeWithSeconds(hittingTime, preferredTimescale: 600)
        //Assign the new values to the start and end time
        
        //      self.export(asset, to: outputPath, startTime: startTime, endTime: endTime, composition: player.currentItem!.videoComposition ?? AVVideoComposition())
        
        //Create trim range
        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        //delete any old file
        do {
            try FileManager.default.removeItem(at: outputPath)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
        
//        PHPhotoLibrary.shared().performChanges({ () -> Void in
//            _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputPath)
//        }, completionHandler: { (success: Bool, error: Error?) -> Void in
//
//            print("Saved")
//        })
        
        
        //create exporter
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080)
        //configure exporter
        //    exporter?.videoComposition = AVVideoComposition()
        exporter?.outputURL = outputPath
        exporter?.outputFileType = .mp4
        exporter?.timeRange = timeRange
        //export!
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    print("failed \(error.localizedDescription)")
                } else {
                    //              let videoData = try Data(contentsOf: outputMovieURL)
                    //              try! videoData.write(to: outputMovieURL, options: .atomic)
                    //            self.saveVideosToPhotos(localURL: outputMovieURL)
                    print("Video saved to \(outputPath)")
                    callback("Video saved to \(outputPath)")
                }
            }
        })
    }
    
    func export(_ asset: AVAsset, to outputMovieURL: URL, startTime: CMTime, endTime: CMTime, composition: AVVideoComposition) {
        //Create trim range
        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        //delete any old file
        do {
            try FileManager.default.removeItem(at: outputMovieURL)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
        //create exporter
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080)
        //configure exporter
        //    exporter?.videoComposition = AVVideoComposition()
        exporter?.outputURL = outputMovieURL
        exporter?.outputFileType = .mp4
        exporter?.timeRange = timeRange
        //export!
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    print("failed \(error.localizedDescription)")
                } else {
                    //              let videoData = try Data(contentsOf: outputMovieURL)
                    //              try! videoData.write(to: outputMovieURL, options: .atomic)
                    //            self.saveVideosToPhotos(localURL: outputMovieURL)
                    print("Video saved to \(outputMovieURL)")
                }
            }
        })
    }
    
    //------------------------------------
    // MARK: Alerts
    //------------------------------------
    func alertSuccess(title: String , message: String){
        SPAlert.present(title: title, message: message, preset: .custom(UIImage.init(named: "M2CIcon")!), haptic: .success)
    }
    
    func alertWarning(title: String , message: String){
        SPAlert.present(title: title, message: message, preset: .custom(UIImage.init(named: "M2CIcon")!), haptic: .error)
    }
    
    func alertError(title: String , message: String){
        SPAlert.present(title: title, message: message, preset: .custom(UIImage.init(named: "M2CIcon")!), haptic: .warning)
    }
    
    func alertSuccessWithDoneButton(title: String , message: String){
        SPAlert.present(title: title, message: message, preset: .custom(UIImage.init(named: "M2CIcon")!), haptic: .warning)
    }
    
    //Activity Indicators
    
    /** Show Indicator with message */
    func showIndicator(withTitle title: String) {
        
        DispatchQueue.main.async {
            let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)//.showAdded(to: self.view, animated: true)
            Indicator.label.text = title
            //        Indicator.mode = MBProgressHUDMode.annularDeterminate
            //Indicator.detailsLabel.text = Description
            
            
            Indicator.show(animated: true)
        }
    }
    
    /** Hide Indicator  */
    func hideIndicator() {
        //        self.view.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
    //get all Captures
    
    func getCaptures(){
        let videos = CoreDataManager.shared.fetchCaptures()
        Global.shared.allCaptures.removeAll()
        if let captures = videos{
            for eachVal in captures{
                let model = CaptureModel(data: eachVal)
                Global.shared.allCaptures.append(model)
            }
        }
    }
    
    func getCapturesWRTDate() -> ([String:[CaptureModel]] , [Date]){
        if(Global.shared.allCaptures.count < 1){
            self.getCaptures()
        }
        let captures = Global.shared.allCaptures.sorted(by: { $0.fullDate > $1.fullDate })
        let dateWiseCaptures = Dictionary(grouping: captures, by: { $0.datedAdded})
        let dates = dateWiseCaptures.keys
        var datesInDateFormat = [Date]()
        for date in dates{
            print(date)
            datesInDateFormat.insert(date.dateFromString() , at: 0)
        }
        return (dateWiseCaptures , datesInDateFormat.sorted().reversed())//.sorted().reversed())
    }
    
    //------------------------------------
    // MARK: Side Menu
    //------------------------------------
    func showSideMenu(){
        let storyBoard = UIStoryboard.init(name: SBSideMenu, bundle: .main)
        let vc = storyBoard.instantiateViewController(withIdentifier: sideMenuVCID) as! SideMenuVC
        let menuVc = SideMenuNavigationController(rootViewController: vc)
        menuVc.leftSide = true
        self.present(menuVc, animated: true, completion: nil)
    }
    
    //------------------------------------
    // MARK: Text Fields
    //------------------------------------
    
    func addRedAsterik(textField: UITextField) {
        let text = textField.placeholder ?? ""
        let textString = NSMutableAttributedString(string: text)
        let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
        textString.append(asterix)
        textField.attributedPlaceholder = textString
    }
    
    //------------------------------------
    // MARK: Gifs
    //------------------------------------
    
    func loadAndShowGif(gifName: String) {
        
        DispatchQueue.main.async {
            
            let vc = self.getVC(storyBoard: SBPopUps, viewController: gifViewControllerID) as! GifViewController
            vc.gifName = gifName
            
            vc.view.isOpaque = false
            vc.view.alpha = 0.7
            self.addChild(vc)
            vc.view.frame = self.view.bounds
            self.view.addSubview((vc.view)!)
            vc.didMove(toParent: self)
            self.view.bringSubviewToFront(vc.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                vc.view.removeFromSuperview()
            })
        }
        
    }
}


