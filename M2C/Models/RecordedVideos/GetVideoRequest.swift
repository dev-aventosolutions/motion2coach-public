//
//  GetVideoRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/11/2022.
//

import Foundation

class GetVideoRequest{
    
    static let shared = GetVideoRequest()
    
    var loggedUserId: String = ""
    var userId: String = ""
    var videoId: String = ""
    
    func returnGetVideosRequestParams() -> [String:Any] {
        
        let params:[String:Any] = [
            "loggedUserId": loggedUserId,
            "userId": userId,
            "videoId": videoId,
            "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
            "deviceType": "iOS"
        ]
        return params
    }
    
}
