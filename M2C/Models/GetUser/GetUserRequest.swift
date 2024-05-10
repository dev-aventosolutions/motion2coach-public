//
//  GetUserRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 29/08/2022.
//

import Foundation

class GetUserRequest{
    
    static let shared = GetUserRequest()
    
    var loggedUserId: String = ""
    var userId: String = ""
    
    func returnGetUserRequestParams() -> [String: String]{
        
        let params:[String: String] = [
            "loggedUserId": loggedUserId,
            "userId": userId,
            "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
            "deviceType": "iOS"
        ]
        return params
    }
}
