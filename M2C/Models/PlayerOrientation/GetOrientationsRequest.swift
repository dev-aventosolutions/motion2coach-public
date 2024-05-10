//
//  GetOrientationsRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 26/09/2022.
//

import Foundation

class GetOrientationRequest{
    
    static let shared = GetOrientationRequest()
    
    var loggedUserId: String = ""
    
    func returnGetOrientationRequestParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "loggedUserId" : loggedUserId,
            "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
            "deviceType": "iOS"
        ]
        return params
    }
}
