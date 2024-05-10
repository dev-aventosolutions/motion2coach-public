//
//  Gender.swift
//  M2C
//
//  Created by Abdul Samad Butt on 20/07/2022.
//

import Foundation

class Gender{
    
    var id: String?
    var name: String?
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
    }
    
}
