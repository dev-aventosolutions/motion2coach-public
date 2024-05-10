//
//  SignUpUser.swift
//  M2C
//
//  Created by Abdul Samad Butt on 28/07/2022.
//

import Foundation

class SignUpUser{
    
    var userId: String = ""
    var userName: String = ""
    var sessionToken: String = ""
    var verificationToken: String = ""
    var message: String = ""
    
    init(json: JSON){
        self.userId = json["userId"].stringValue
        self.userName = json["userName"].stringValue
        self.sessionToken = json["sessionToken"].stringValue
        self.verificationToken = json["verificationToken"].stringValue
        self.message = json["message"].stringValue
    }
}
