//
//  Services.swift
//  ODIE
//
//  Created by Abdul Samad on 19/01/2022.
//


import Foundation
import Alamofire
import UIKit

protocol ServerResponse: AnyObject {
    func onSuccess(json:JSON,val:String)
    func onSuccess(data: Data, val:String)
    func onFailure(json: JSON?,val:String)
}

extension ServerResponse{
    func onSuccess(json:JSON,val:String){}
    func onSuccess(data: Data, val:String){}
    func onFailure(json: JSON?,val:String){}
}

//@available(iOS 13.0, *)
class Services: UIViewController {
    
    weak var delegate:ServerResponse?
    
    
    
    deinit {
    }
    
    func returnHeaders(headerType: HeaderType) -> HTTPHeaders{
        if headerType == .headerWithoutAuth{
            let headersWithoutAuth: HTTPHeaders = [
                "Content-Type": "application/json",
                "appversion": (Bundle.main.releaseVersionNumber ?? ""),
                "deviceid": getUUID(),
                "devicetype": "iOS"
            ]
            return headersWithoutAuth
        }else{
            let token = userDefault.getValue(key: UDKey.userToken)
            let headersWithAuth: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "appversion": (Bundle.main.releaseVersionNumber ?? ""),
                "deviceid": getUUID(),
                "devicetype": "iOS"
            ]
            return headersWithAuth
        }
    }
    
    // MARK: Request with body and header
    func requestWithHeaderandBody(vc:UIViewController , url:String , params:[String:Any] , method:HTTPMethod , type:String , loading:Bool, showErrorPrompt: Bool? = true, headerType: HeaderType){
        
        let loaderVC = LoaderViewController.initFrom(storyboard: .general)
        let apiHeader = returnHeaders(headerType: headerType)
        
        if CheckInternet.Connection(){
            if loading{
                loaderVC.modalPresentationStyle = .overCurrentContext
                vc.present(loaderVC, animated: false, completion: nil)
            }
            
            AF.request(url , method: method, parameters: params , encoding: JSONEncoding.default, headers: apiHeader).responseJSON { (response) in
                
                switch response.result{
                    
                case .success(let value):
                    
                    let json = JSON(value)
                    let statusCode = response.response?.statusCode
                    let responseData = try! JSONSerialization.data(withJSONObject: value, options: [])
                    
                    // if API hits with no error i.e status
                    if statusCode == 200{
                        
                        loaderVC.dismiss(animated: false, completion: nil)
                        if let del = self.delegate{
                            del.onSuccess(data: responseData, val: type)
                            del.onSuccess(json: json, val: type)
                        }
                    } else if statusCode == 502{
                        
                        loaderVC.dismiss(animated: false) {
                            if let showErrorPrompt = showErrorPrompt{
                                if showErrorPrompt{
                                    vc.showPopupAlert(title: Messages.error, message: "Internal Server Error", btnOkTitle: "Ok")
                                }
                            }
                        }
                        
                    } else if statusCode == 401{
                        
                        loaderVC.dismiss(animated: false) {
                            if let showErrorPrompt = showErrorPrompt{
                                if showErrorPrompt{
                                    vc.showPopupAlert(title: Messages.error, message: "Session Timeout", btnOkTitle: "Ok", onOK: {
                                        userDefault.deleteValue(key: UDKey.savedUser)
                                        AppDelegate.app.moveToLogin()
                                    })
                                }
                            }
                        }
                    } else if statusCode == 402{
                        // Only for Subscription API
                        loaderVC.dismiss(animated: false, completion: nil)
                        if let del = self.delegate{
                            del.onSuccess(data: responseData, val: type)
                            del.onSuccess(json: json, val: type)
                        }
                        
                    } else{
                        loaderVC.dismiss(animated: false) {
                            if let showErrorPrompt = showErrorPrompt{
                                if showErrorPrompt{
                                    vc.showPopupAlert(title: Messages.error, message: json["message"].stringValue, btnOkTitle: "Ok")
                                }
                            }
                        }
                        if let del = self.delegate{
                            del.onFailure(json: json, val: type)
                        }
                    }
                    
                case .failure(let err):
                    if let del = self.delegate{
                        del.onFailure(json: nil, val: type)
                    }
                    
                    print(err.localizedDescription)
                    loaderVC.dismiss(animated: false) {
                        if let showErrorPrompt = showErrorPrompt{
                            if showErrorPrompt{
                                vc.showPopupAlert(title: Messages.error, message: Messages.serviceFailure, btnOkTitle: "Ok")
                            }
                        }
                        
                    }
                    break
                }
            }.resume()
        }else{
            vc.showPopupAlert(title: Messages.error, message: Messages.noInternet, btnOkTitle: "Ok")
        }
    }
    
    // MARK: Put Request
    func requestPutApi(vc:UIViewController , url:String , params:[String:Any] , method:HTTPMethod , type:String , loading:Bool, headerType: HeaderType){
        
        let loaderVC = LoaderViewController.initFrom(storyboard: .general)
        let apiHeader = returnHeaders(headerType: headerType)
        
        if CheckInternet.Connection(){
            if loading{
                loaderVC.modalPresentationStyle = .overCurrentContext
                vc.present(loaderVC, animated: false, completion: nil)
            }
            
            AF.request(ServiceUrls.baseUrlM2c + url , method: method, parameters: params , encoding: JSONEncoding.default, headers: apiHeader).responseJSON { (response) in
                
                switch response.result{
                    
                case .success(let value):
                    
                    let json = JSON(value)
                    let statusCode = response.response?.statusCode
                    let responseData = try! JSONSerialization.data(withJSONObject: value, options: [])
                    
                    // if API hits with no error i.e status
                    if statusCode == 200{
                        
                        loaderVC.dismiss(animated: false, completion: nil)
                        if let del = self.delegate{
                            del.onSuccess(data: responseData, val: type)
                            del.onSuccess(json: json, val: type)
                        }
                    } else if statusCode == 502{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: "Internal Server Error", btnOkTitle: "Ok")
                        }
                    } else if statusCode == 401{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: "Session Timeout", btnOkTitle: "Ok", onOK: {
                                userDefault.deleteValue(key: UDKey.savedUser)
                                AppDelegate.app.moveToLogin()
                            })
                        }
                    } else{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: json["message"].stringValue, btnOkTitle: "Ok")
                        }
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    loaderVC.dismiss(animated: false) {
                        vc.showPopupAlert(title: Messages.error, message: Messages.serviceFailure, btnOkTitle: "Ok")
                    }
                    break
                }
            }.resume()
        }else{
            vc.showPopupAlert(title: Messages.error, message: Messages.noInternet, btnOkTitle: "Ok")
        }
    }
    
    // MARK: Request GET API
    func requestGETAPI(vc: UIViewController , url : String, method: HTTPMethod, type: String, loading: Bool, headerType: HeaderType) {
        
        let loaderVC = LoaderViewController.initFrom(storyboard: .general)
        let apiHeader = returnHeaders(headerType: headerType)
        
        if CheckInternet.Connection(){
            if loading{
                
                loaderVC.modalPresentationStyle = .overCurrentContext
                vc.present(loaderVC, animated: false, completion: nil)
            }
            
            AF.request(ServiceUrls.baseUrlM2c + url , method: method , encoding: URLEncoding.default, headers: apiHeader).responseJSON { (response) in
                
                switch response.result{
                    
                case .success(let value):

                    let json = JSON(value)
                    let responseData = try! JSONSerialization.data(withJSONObject: value, options: [])
                    let statusCode = response.response?.statusCode
                    
                    // if API hits with no error i.e status
                    if statusCode == 200{
                        
                        loaderVC.dismiss(animated: false, completion: nil)
                        if let del = self.delegate{
                            del.onSuccess(data: responseData, val: type)
                            del.onSuccess(json: json, val: type)
                        }
                    } else if statusCode == 502{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: "Internal Server Error", btnOkTitle: "Ok")
                        }
                    } else if statusCode == 401{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: "Session Timeout", btnOkTitle: "Ok", onOK: {
                                userDefault.deleteValue(key: UDKey.savedUser)
                                AppDelegate.app.moveToLogin()
                            })
                        }
                    } else{
                        
                        loaderVC.dismiss(animated: false) {
                            vc.showPopupAlert(title: Messages.error, message: "Service Failure", btnOkTitle: "Ok")
                        }
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    loaderVC.dismiss(animated: false) {
                        vc.showPopupAlert(title: Messages.error, message: Messages.serviceFailure, btnOkTitle: "Ok")
                    }
                    
                }
            }
        }else{
            loaderVC.dismiss(animated: false){
                self.showPopupAlert(title: Messages.error, message: Messages.noInternet, btnOkTitle: "Ok")
            }
        }
    }
}
