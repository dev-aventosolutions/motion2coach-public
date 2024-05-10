//
//  Country.swift
//  M2C
//
//  Created by Abdul Samad Butt on 20/07/2022.
//

import Foundation

class Country{
    
    var id: String?
    var name: String?
    var phoneCode: String?
    var sortName: String?
    var uniCode: String?
    var imageUrl: String?
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.phoneCode = json["phoneCode"].stringValue
        self.sortName = json["sortName"].stringValue
        self.uniCode = json["unicode"].stringValue
        self.imageUrl = json["image"].stringValue
    }
    
    init(){
        
    }
    
}
