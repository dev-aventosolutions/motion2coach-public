//
//  Role.swift
//  M2C
//
//  Created by Abdul Samad Butt on 20/07/2022.
//

import Foundation

class Role{
    
    var id: String?
    var roleName: String?
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.roleName = json["roleName"].stringValue
    }
    
}

//struct RoleList: Codable{
//    var arrRoles = [Role]()
//}
//
//struct Role: Codable{
//    var roleName: String
//    var id: Int
//}
