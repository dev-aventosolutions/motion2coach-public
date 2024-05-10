//
//  Orientation.swift
//  M2C
//
//  Created by Abdul Samad Butt on 26/09/2022.
//

import Foundation

class PlayerOrientation{
    
    var id: String?
    var name: String?
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
    }
    
    init(){}
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}
