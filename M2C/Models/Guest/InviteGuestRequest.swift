//
//  InviteGuestRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/01/2023.
//

import Foundation

class InviteGuestRequest{
    
    static let shared = InviteGuestRequest()
    
    var loggedUserId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var genderId: String = ""
    var playerType: String = ""
    var email: String = ""
    
    
    func returnInviteGuestRequest() -> [String:Any] {
        
        let params:[String:Any] = [
            "loggedUserId": Global.shared.loginUser?.userId.toInt() ?? 0,
            "roleId": Global.shared.loginUser?.roleId ?? "",
            "userFirstName": firstName,
            "userLastName": lastName,
            "userGenderId": genderId,
            "userPlayerType": playerType,
            "userEmail": email,
        ]
        return params
    }
    
}

