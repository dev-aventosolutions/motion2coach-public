//
//  CoreDataManager.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 12/05/2022.
//

import Foundation
import CoreData
import Photos
import UIKit

protocol APICallsFromCoreDataManagerDelegate : AnyObject{
    func callsStarted()
    func callsEnded()
}

class CoreDataManager{
    static let shared = CoreDataManager()
    
    static var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not determine appDelegate.")
        }
        return appDelegate
    }
    
    //MARK: MANAGED COBJECT CONTEXT
    static var managedObjectContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    static func clearDatabase() {
        
        let applicationSupportDirectoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let applicationSupportDirectoryPath = applicationSupportDirectoryPath.first{
            let sqlPath = applicationSupportDirectoryPath + "/" + "M2C.sqlite"
            let url = URL(fileURLWithPath: sqlPath)
            
            let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator
            
            do {
                try persistentStoreCoordinator?.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
                try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch {
                print("Attempted to clear persistent store: " + error.localizedDescription)
            }
        }
        
    }
    
    func createCapture(url: URL,binary: Data, dateAdded: Date){
        
        let videoCaptureEntity = NSEntityDescription.insertNewObject(forEntityName: "CaptureEntity", into: CoreDataManager.managedObjectContext) as! CaptureEntity
        var countCaptures = 0
        if let count = userDefault.value(forKey: countOfCaptures) as? Int{
            countCaptures = count
        }
        
        videoCaptureEntity.videoName = "m2c-iOS-\(Global.shared.loginUser?.userId ?? "")-\(Date.currentTimeStamp)"
        videoCaptureEntity.videoBinary = binary
        videoCaptureEntity.videoUrl = url.absoluteString
        videoCaptureEntity.datedAdded = dateAdded
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { (success: Bool, error: Error?) -> Void in
            // Must use Dispatch to display label text on main thread
            DispatchQueue.main.async {
                if success {
                    if let image = self.generateThumbnail(path: url){
                        let data = image.pngRepresentationData
                        videoCaptureEntity.thumbnail = data
                        
                    }
                    do{
                        userDefault.setValue(countCaptures + 1, forKey: countOfCaptures)
                        try CoreDataManager.managedObjectContext.save()
                        let capture = CaptureModel(data: videoCaptureEntity)
                        
                        self.uploadMedia(capture: capture)
                    } catch let createErr{
                        print("Failed to create new Capture: \(createErr)")
                    }
                    //                    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    //                    DispatchQueue.main.async {
                    //
                    //                        do {
                    //
                    //                            try FileManager.default.moveItem(at: url, to: documentsDirectoryURL.appendingPathComponent(""))
                    //                            try CoreDataManager.managedObjectContext.save()
                    //                            let capture = CaptureModel(data: videoCaptureEntity)
                    //                            self.uploadMedia(capture: capture)
                    //                            print("movie saved")
                    //                        } catch {
                    //                            print(error)
                    //                        }
                    //                    }
                    //                    Global.shared.allCaptures.removeAll()
                    //                    print("Successfully Video Saved")
                } else {
                    print("Fail to Save Video: " + "\(String(describing: error?.localizedDescription))")
                }
            } // end Disptach
        }) // end in closure
    }
    
    func fetchCaptures() -> [CaptureEntity]?{
        //        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CaptureEntity>(entityName: "CaptureEntity")
        
        do{
            let details = try CoreDataManager.managedObjectContext.fetch(fetchRequest)
            return details
        } catch let fetchErr{
            print("Could find Captures: \(fetchErr)")
        }
        return nil
    }
    
    func deleteCapture(capture: CaptureEntity) {
        //        let context = persistentContainer.viewContext
        CoreDataManager.managedObjectContext.delete(capture)
        
        do {
            try CoreDataManager.managedObjectContext.save()
        }catch{
            print("Unable to delete capture")
        }
        
    }
    
    func deleteByName(name: String) {
        let captures = self.fetchCaptures()
        if let videos = captures {
            for i in 0..<videos.count {
                let video = CaptureModel(data: videos[i])
                if video.videoName == name {
                    CoreDataManager.managedObjectContext.delete(videos[i])
                    do {
                        try CoreDataManager.managedObjectContext.save()
                    }catch{
                        print("Unable to delete capture")
                    }
                    break
                }
            }
        }
    }
    
    func fetchCaptures(at index: Int) -> CaptureEntity?{
        //        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CaptureEntity>(entityName: "CaptureEntity")
        
        do{
            let details = try CoreDataManager.managedObjectContext.fetch(fetchRequest)
            return details[index]
        } catch let fetchErr{
            print("Could find Captures: \(fetchErr)")
        }
        return nil
    }
    
    func fetchLastCapture() -> CaptureEntity{
        //        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CaptureEntity>(entityName: "CaptureEntity")
        
        do{
            let details = try CoreDataManager.managedObjectContext.fetch(fetchRequest)
            if(details.count > 0){
                return details.last ?? CaptureEntity()
            }
        } catch let fetchErr{
            print("Could find Captures: \(fetchErr)")
        }
        return CaptureEntity()
    }
    
    func updateLastCapture(publicUrl: String){
        
        let fetchRequest = NSFetchRequest<CaptureEntity>(entityName: "CaptureEntity")
        do{
            let details = try CoreDataManager.managedObjectContext.fetch(fetchRequest)
            if(details.count > 0){
                details.last?.publicUrl = publicUrl
                Global.shared.selectedCapture = CaptureModel(data: details.last ?? CaptureEntity())
                try CoreDataManager.managedObjectContext.save()
            }
        } catch let updateErr{
            print("Could update Capture: \(updateErr)")
        }
    }
    
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}

//MARK: VIDEO UPLOADING
extension CoreDataManager{
    
    
    
    //MARK: Step 1
    func uploadMedia(capture: CaptureModel){
        var uploadingFor: String = "0"
        if let striker = Global.shared.selectedStriker {
            uploadingFor = striker.userId
        }
        
        let params: [String: String] = ["fileMimeType" : "video/mov",
                                        "fileName" : (capture.videoName.replacingOccurrences(of: " ", with: "") + ".mp4"),
                                        "uploadingFor": uploadingFor]
        
        NotificationCenter.default.post(name: .videoUploadStep1, object: self, userInfo: ["capture": capture])
        
        ServiceManager.shared.uploadVideo(parameters: params, success: { response in
            
            let json = JSON(response)
            
            if let signedUrl = json["signedUrl"].string {
                
                self.uploadOnSignedURL(signedURL: signedUrl, capture: capture, publicUrl: json["publicUrl"].stringValue)
            }
            else{
                
            }
            
        }, failure: { response in
            NotificationCenter.default.post(name: .videoUploadErrorStep1, object: self, userInfo: nil)
            print(response)
        })
        
    }
    
    //MARK: Step 2
    func uploadOnSignedURL(signedURL: String, capture: CaptureModel, publicUrl: String){
        
        NotificationCenter.default.post(name: .videoUploadStep2, object: self)
        
        ServiceManager.shared.multipartRequestForVideo(url: signedURL, capture: capture, fileExtention: ".mp4", parameters: [String : String](), success: {
            response in
            if (response as! String) == "video uploaded"{
                print(response)
                
                // If video is uploading for striker
                if let striker = Global.shared.selectedStriker{
                    self.addVideo(capture: capture, publicUrl: publicUrl, uploadingFor: striker.userId.toInt())
                }else{
                    // If video is uploading for user itself
                    self.addVideo(capture: capture, publicUrl: publicUrl, uploadingFor: (Global.shared.loginUser?.userId.toInt())!)
                }
                
            }
            
        }, failure: {
            response in
            NotificationCenter.default.post(name: .videoUploadErrorStep2, object: self, userInfo: nil)
            print(response)
        })
    }
    
    //MARK: Step 3
    func addVideo(capture: CaptureModel, publicUrl: String, uploadingFor: Int){
        
        NotificationCenter.default.post(name: .videoUploadStep3, object: self)
        
        let playerType: String = Global.shared.loginUser?.playerTypeId ?? ""
        let loggedUserId: String = Global.shared.loginUser?.userId ?? ""
        
        // Setting up weight and height
        var weight: String = "1"
        var height: String = "1"
        
        // If striker is selected
        if let selectedStriker = Global.shared.selectedStriker{
            weight = selectedStriker.weight
            height = selectedStriker.height
        }else{
            // If video is getting uploaded for user himself
            weight = Global.shared.loginUser?.weight ?? "1"
            height = Global.shared.loginUser?.height ?? "1"
        }
        
//        let formatter: NumberFormatter = NumberFormatter()
//        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
//        let finalWeight = formatter.number(from: weight)
//        let doubleNumber = Double(finalWeight!)
        
        // Temp hardcoded 2 player type id
        let params: [String: Any] = ["loggedUserId" : loggedUserId,
                                     //                      "title" : (capture.videoName.replacingOccurrences(of: " ", with: "") + ".mp4"),
                                     "uploadingFor": uploadingFor,
                                     "title" : (capture.videoName.replacingOccurrences(of: " ", with: "")),
                                     "description" : "video",
                                     "videoUrl" : publicUrl,
                                     "videoRating" : "5",
                                     "orientation": Global.shared.selectedOrientation?.id?.toString() ?? "2",
                                     "playerType": Global.shared.loginUser?.playerTypeId ?? "2",
                                     "swingType": Global.shared.selectedSwingType?.id ?? 1,
                                     "clubType": Global.shared.selectedClubType?.id ?? 1,
                                     "frameRate": "120",
                                     "deviceType": "iOS",
                                     "weight": weight,
                                     "height": height]
        
        ServiceManager.shared.addVideo(parameters: params, success: { response in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isAPICallEnded"), object: self)
            
            let data = response as? NSDictionary ?? NSDictionary()
            
            DocumentDirectory.saveData(data: capture.videoBinary, name: capture.videoName)
            
            if let trackingServer = data["trackingServer"] as? String {
                if trackingServer == "available"{
                    // If the server is available
                    
                    // Have to save this Url in Core Data
                    if let overlayUrl = data["overlayUrl"] as? String{
                        
                        // Saving overlay url in Core Data
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureEntity")
                        fetchRequest.predicate = NSPredicate(format: "videoName = %@", capture.videoName)
                        
                        do {
                            if let fetchResults = try CoreDataManager.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                                if fetchResults.count != 0{
                                    
                                    let managedObject = fetchResults[0]
                                    
                                    managedObject.setValue(overlayUrl, forKey: "overlayUrl")
                                    managedObject.setValue(Global.shared.selectedOrientation?.name, forKey: "orientation")
                                    managedObject.setValue("uploaded", forKey: "status")
                                    
                                    try! CoreDataManager.managedObjectContext.save()
                                }
                            }
                        } catch let err{
                            print(err)
                        }
                        
                        let url = data["url"] as? String
                        self.getOverlayUrl(overlayUrl: overlayUrl, url: url ?? "")
                    }
                    else{
                        //throw error
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isAPICallEnded"), object: self)
                    }
                    
                }else if trackingServer == "busy"{
                    // If the server is busy or any other status
                    NotificationCenter.default.post(name: .serverStatus, object: self, userInfo: ["trackingStatus": trackingServer])
                    print("Server Status: \(trackingServer)")
                    
                }else{
                    
                    
                }
            }
            
        }, failure: { response in
            NotificationCenter.default.post(name: .videoUploadErrorStep3, object: self, userInfo: nil)
            print(response)
        })
        
    }
    
    //MARK: Step 4(Getting overlay URL)
    func getOverlayUrl(overlayUrl: String, url: String){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            let params = ["url" : overlayUrl]
            
            ServiceManager.shared.getOverlayVideo(parameters: params, success: { response in
                
                let data = response as? String
                
                print(data ?? "")
                NotificationCenter.default.post(name: .videoUploadStep4, object: self, userInfo: ["videoDownloadUrl": data ?? "", "videoOverlayUrl": overlayUrl, "url":  url])
                
            }, failure: { response in
                NotificationCenter.default.post(name: .videoUploadErrorStep4, object: self, userInfo: nil)
                print(response)
            })
        }
    }
}
