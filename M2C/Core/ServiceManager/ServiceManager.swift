//
//  ServiceManager.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import Alamofire
import SDWebImage
import Photos

class ServiceManager {
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    
    static let shared = ServiceManager()
    private let manager = AF
    private var headers = HTTPHeaders()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //------------------------------------
    // MARK: Configure
    //------------------------------------
    
    private init() {
        
    }
    
    
    private func setupManager() {
        
        manager.session.configuration.timeoutIntervalForRequest = ServiceConstants.ServiceError.timeOutInterval
        
        headers = [
            //            "Authorization" : "Bearer",
            "Content-Type" :  "application/json",
            "appversion": (Bundle.main.releaseVersionNumber ?? ""),
            "devicetype": "iOS",
            "deviceid": getUUID(),
            "Accept": "*/*",
            "Accept-Encoding" : "gzip, deflate, br"
        ]
        
        
    }
    
    func stopSession(){
        manager.session.invalidateAndCancel()
    }
    
    
    //=======================================
    // MARK: Methods
    //=======================================
    
    //Upload Video
    
    func uploadVideo(parameters: [String : String], success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.uploadMedia
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        if response.response?.statusCode == 200{
                            success(responseDict)
                        }else{
                            var serviceError = ServiceError()
                            serviceError.message = responseDict["message"] as! String
                            failure(serviceError)
                        }
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    func multipartRequestForImage(vc: UIViewController, url: String, imageBinary: Data, loading:Bool, success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        
        let loaderVC = LoaderViewController.initFrom(storyboard: .general)
        
        if (NetworkReachability.isAvailable) {
            if loading{
                loaderVC.modalPresentationStyle = .overCurrentContext
                vc.present(loaderVC, animated: false, completion: nil)
            }
            
            let apiUrl = URL(string: url) ?? URL(string: "")
            
            AF.upload(imageBinary, to: apiUrl!, method: .put).response { (response) in
                print(response.response?.statusCode ?? 0)
                loaderVC.dismiss(animated: false, completion: nil)
                success(response)
            }.resume()
        }
    }
    
    func multipartRequestForVideo(url: String, capture: CaptureModel, fileExtention:String?, parameters : [String:String], success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            
            let apiUrl: URL = URL(string: url) ?? URL(string: "")!
            print(apiUrl as Any)
            
            AF.upload(capture.videoBinary, to: apiUrl, method: .put).response { response in
                if response.response?.statusCode == 200{
                    success("video uploaded")
                }
            }.resume()
            
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
    }
    
    func addVideo(parameters: [String : Any], success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.addVideo
            
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        if response.response?.statusCode == 200{
                            success(responseDict)
                        }else{
                            var serviceError = ServiceError()
                            serviceError.message = responseDict["message"] as! String
                            failure(serviceError)
                        }
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    
    func addScannedImage(parameters: [String : Any], success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.addScannedImage
            
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        success(responseDict)
                        
                    }
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    
    //----------------------------- Sign In
    //Respective functions
    //login api call
    func loginCall(parameters: [String : String],success: @escaping (Any) -> Void, failure: @escaping (Any) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.loginUrl
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        if response.response?.statusCode == 200{
                            success(responseDict)
                        }else{
                            failure(JSON(responseDict))
                        }
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    
    // Get User Profile
    func getUserProfile(parameters: [String : String],success: @escaping (Any) -> Void, failure: @escaping (Any) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getUser
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        if response.response?.statusCode == 200{
                            success(responseDict)
                        }else{
                            failure(JSON(responseDict))
                        }
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    func getKinematicsReport(parameters: [String : String],success: @escaping (JSON) -> Void, failure: @escaping (ServiceError) -> Void) {
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.kinematicAnalysis
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).response { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200{
                        success(JSON(json as Any))
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
    }
    
    
    // Get Highlights
    func getHighlights(parameters: [String : String],success: @escaping (JSON) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.getHighlights
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).response { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200{
                        success(JSON(json as Any))
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
//                    if let responseDict = json as? NSDictionary{
//                        if response.response?.statusCode == 200{
//                            success(JSON(responseDict))
//                        }else{
//
//                        }
//                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    // Get Highlights
    func getHighlights2(parameters: [String : String],success: @escaping (JSON) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.getHighlights2
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).response { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200{
                        success(JSON(json as Any))
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
//                    if let responseDict = json as? NSDictionary{
//                        if response.response?.statusCode == 200{
//                            success(JSON(responseDict))
//                        }else{
//
//                        }
//                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    // Get Description
    func getDescription(parameters: [String : String],success: @escaping (JSON) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.getDescription
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).response { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200{
                        success(JSON(json as Any))
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    // Get Highlight Positions
    func getHighlightPositions(parameters: [String : String],success: @escaping (JSON) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable) {
            
            let apiUrl = ServiceUrls.baseUrlBioMechanics + ServiceUrls.URLs.getHighlightPositions
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).response { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200 {
                        success(JSON(json as Any))
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    func signUpCall(url: String, success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + url
            print(apiUrl)
            setupManager()
            manager.request(apiUrl, method: .post, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        
                        success(responseDict)
                        
                    }
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    
    // Get Overlay Video
    func getOverlayVideo(parameters: [String : String],success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            let apiUrl = ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getOverlayUrl
            print(apiUrl)
            setupManager()
            
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    
                    if response.response?.statusCode == 200{
                        success(json)
                    }else{
                        var serviceError = ServiceError()
                        let errorJson = JSON(json as Any)
                        serviceError.message = errorJson["message"].stringValue
                        failure(serviceError)
                    }
                    
//                    if let responseDict = json as? NSDictionary{
//                        if response.response?.statusCode == 200{
//                            success(JSON(responseDict))
//                        }else{
//
//                        }
//                    }
                    
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    failure(serviceError)
                }
            }.resume()
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    func downloadVideo(videoName: String, success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void){
        let videoUrl = "https://motion2coach-computervision-results.s3.eu-central-1.amazonaws.com/\(videoName).mp4"

        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/m2c_results/\(videoName)_result.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                            success("Video Downloaded")
                        }
                        if error != nil {
                            print("Unable to download the video.")
                            var serviceError = ServiceError()
                            serviceError.message = "Unable to download the video."
                            failure(serviceError)
                        }
                    }
                }
            }
        }
    }
}
