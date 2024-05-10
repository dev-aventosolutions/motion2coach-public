//
//  UpdateUserRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 29/08/2022.
//

import Foundation

class UpdateUserRequest{
    
    static let shared = UpdateUserRequest()
    
    var firstName: String = ""
    var lastName: String = ""
    var contactNum: String = ""
    var houseNo: String = ""
    var postCode: String = ""
    var city: String = ""
    var address: String = ""
    var roleId: String = ""
    var genderId: String = ""
    var playerTypeId: String = ""
    var dateOfBirth: String = ""
    var email: String = ""
    var picture: String = ""
    
    func returnUpdateUserRequestParams() -> [String:Any] {
        
        let params:[String:Any] = [
            "loggedUserId": Global.shared.loginUser?.userId ?? "",
            "userId": Global.shared.loginUser?.userId ?? "",
            
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNum,
            "address": address,
            "houseNo": houseNo,
            "postCode": postCode,
            "city": city,
            
            "picture": picture,
            "role": roleId,
            "genderId": genderId,
            "playerTypeId": playerTypeId,
            "dateOfBirth": dateOfBirth,
            "email": email,
        ]
        return params
    }
}
