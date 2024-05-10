//
//  ClubType.swift
//  M2C
//
//  Created by Fenris GMBH on 03/03/2023.
//

import Foundation

class ClubType{
    
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
