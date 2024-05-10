//
//  File.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/01/2023.
//

import Foundation

class DeleteUserRequest{
    
    static let shared = DeleteUserRequest()
    
    var password: String = ""
    
    func returnDeleteUserRequest() -> [String:Any] {
        
        let params:[String:Any] = [
            "loggedUserId": Global.shared.loginUser?.userId ?? "",
            "email": Global.shared.loginUser?.email ?? "",
            "password": password,
            "roleId": Global.shared.loginUser?.roleId ?? ""
        ]
        return params
    }
    
}
