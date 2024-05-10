//
//  SignUpRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/07/2022.
//

import Foundation

class SignUpRequest{
    
    static let shared  = SignUpRequest()
    
    var firstName: String = ""
    var lastName: String = ""
    var dateOfBirth: String = ""
    var genderId: String = ""
    var role: String = ""
    var playerType: String = ""
    var address: String = ""
    var postCode: String = ""
    var contactNumber: String = ""
    var houseNo: String = ""
    var city: String = ""
    var email: String = ""
    var password: String = ""
    var registrationDate: String = ""
    var picture: String = ""
    var deviceId: String = ""
    
    func returnSignupParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "firstName" : firstName,
            "lastName" : lastName,
            "dateOfBirth" : dateOfBirth,
            "genderId" : genderId,
            "role" : role,
            "address" : address,
            "postCode" : postCode,
            "contactNumber" : contactNumber,
            "houseNo" : houseNo,
            "city" : city.toInt(),
            "email" : email,
            "password" : password,
            "registrationDate" : registrationDate,
            "picture": picture,
            "playerType": playerType,
            "deviceId": getUUID()
        ]
        return params
    }
}
