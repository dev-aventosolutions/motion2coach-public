//
//  City.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/07/2022.
//

import Foundation

class City{
    
    var id: String?
    var name: String?
    var stateId: String?
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.stateId = json["stateId"].stringValue
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.stateId = ""
    }
    
}
