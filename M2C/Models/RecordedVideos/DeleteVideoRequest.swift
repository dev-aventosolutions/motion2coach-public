//
//  DeleteVideo.swift
//  M2C
//
//  Created by Abdul Samad Butt on 15/11/2022.
//

import Foundation

class DeleteVideoRequest{
    
    static let shared = DeleteVideoRequest()
    
    var loggedUserId: String = ""
    var url: String = ""
    
    func returnDeleteVideosRequestParams() -> [String:Any] {
        
        let params:[String:Any] = [
            "loggedUserId": loggedUserId,
            "url": url
        ]
        return params
    }
    
}
