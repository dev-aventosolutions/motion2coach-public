//
//  ChangePasswordRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 29/08/2022.
//

import Foundation

class ChangePasswordRequest{
    
    static let shared = ChangePasswordRequest()
    
    var loggedUserId: String = ""
    var oldPassword: String = ""
    var newPassword: String = ""
    
    func returnChangePasswordRequestParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "loggedUserId" : loggedUserId,
            "oldPassword" : oldPassword,
            "newPassword" : newPassword
        ]
        return params
    }
}
