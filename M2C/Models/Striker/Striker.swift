//
//  Striker.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/12/2022.
//

import Foundation

class Striker{
    
    var createdAt: String = ""
    var useremail: String = ""
    var coachplayerTypeId: String = ""
    var userfirstName: String = ""
    var updatedAt: String = ""
    var coachpicture: String = ""
    var coachemail: String = ""
    var userpicture: String = ""
    var userplayerTypeId: String = ""
    var userId: String = ""
    var coachId: String = ""
    var coachfirstName: String = ""
    var accepted: Bool = true
    var coachlastName: String = ""
    var userlastName: String = ""
    var userPlayerType: String = ""
    var weight: String = ""
    var height: String = ""
    
    init(){}
    
    init(json: JSON) {
        self.createdAt = json["createdAt"].stringValue
        self.useremail = json["useremail"].stringValue
        self.coachplayerTypeId = json["coachplayerTypeId"].stringValue
        self.userfirstName = json["userfirstName"].stringValue
        self.updatedAt = json["updatedAt"].stringValue
        self.coachpicture = json["coachpicture"].stringValue
        self.coachemail = json["coachemail"].stringValue
        self.userpicture = json["userpicture"].stringValue
        self.userplayerTypeId = json["userplayerTypeId"].stringValue
        self.userId = json["userId"].stringValue
        self.coachId = json["coachId"].stringValue
        self.coachfirstName = json["coachfirstName"].stringValue
        self.accepted = json["accepted"].boolValue
        self.coachlastName = json["coachlastName"].stringValue
        self.userlastName = json["userlastName"].stringValue
        self.userPlayerType = json["userplayerType"].stringValue
    }
    
}
