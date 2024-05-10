//
//  CheckEmail.swift
//  M2C
//
//  Created by Abdul Samad Butt on 31/10/2022.
//

import Foundation

class CheckEmail{
    
    var userName: String?
    var active: Bool?
    
    init(json: JSON){
        self.userName = json["userName"].string
        self.active = json["active"].bool
    }
}
