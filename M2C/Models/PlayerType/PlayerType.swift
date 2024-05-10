//
//  PlayerType.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/09/2022.
//

import Foundation

class PlayerType{
    
    var id: String?
    var name: String?
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
    }
}
