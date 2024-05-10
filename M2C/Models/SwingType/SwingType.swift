//
//  SwingType.swift
//  M2C
//
//  Created by Fenris GMBH on 28/02/2023.
//

import Foundation

class SwingType{
    
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
