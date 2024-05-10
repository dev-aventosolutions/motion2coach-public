//
//  LoginUser.swift
//  M2C
//
//  Created by Abdul Samad Butt on 04/08/2022.
//

import Foundation

class LoginUser: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var userId: String = ""
    var email: String = ""
    var playerTypeId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var roleId: String = ""
    var picturePath: String = ""
    var createdOn: String = ""
    var sessionToken: String = ""
    var active: String = ""
    var roleName: String = ""
    var isGuest: Bool = false
    var subscriptionExpiry: String = ""
    var subscriptionId: String = ""
    var subscriptionName: String = ""
    var weight: String = ""
    var height: String = ""
    var isSubscriptionActive: Bool = true

    override init(){
        print("Init called with empty constructor")
    }
    
    init(userId: String, firstName: String, lastName: String, roleId: String, picturePath: String, createdOn: String, sessionToken: String, active: String, roleName: String, email: String, playerTypeId: String, isGuest: Bool, subscriptionExpiry: String, subscriptionId: String, subscriptionName: String, isSubscriptionActive: Bool, weight: String, height: String){
        
        self.playerTypeId = playerTypeId
        self.email = email
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.roleId = roleId
        self.picturePath = picturePath
        self.createdOn = createdOn
        self.sessionToken = sessionToken
        self.active = active
        self.roleName = roleName
        self.isGuest = isGuest
        self.subscriptionId = subscriptionId
        self.subscriptionName = subscriptionName
        self.subscriptionExpiry = subscriptionExpiry
        self.weight = weight
        self.height = height
        self.isSubscriptionActive = isSubscriptionActive
        
        super.init()        // call NSObject's init method
    }
    
    init(json: JSON){
        userId = json["userId"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        roleId = json["roleId"].stringValue
        picturePath = json["picturePath"].stringValue
        createdOn = json["createdOn"].stringValue
        sessionToken = json["sessionToken"].stringValue
        active = json["active"].stringValue
        roleName = json["roleName"].stringValue
        playerTypeId = json["playerTypeId"].stringValue
        isGuest = json["guestUser"].boolValue
        subscriptionId = json["subscriptionId"].stringValue
        subscriptionName = json["subscriptionName"].stringValue
        subscriptionExpiry = json["subscriptionExpiry"].stringValue
        isSubscriptionActive = json["isSubscriptionActive"].boolValue
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey: "email")
        coder.encode(playerTypeId, forKey: "player_type_id")
        coder.encode(userId, forKey: "user_id")
        coder.encode(firstName, forKey: "first_name")
        coder.encode(lastName, forKey: "last_name")
        coder.encode(roleId, forKey: "role_id")
        coder.encode(picturePath, forKey: "picture_path")
        coder.encode(createdOn, forKey: "created_on")
        coder.encode(sessionToken, forKey: "session_token")
        coder.encode(active, forKey: "active")
        coder.encode(roleName, forKey: "role_name")
        coder.encode(isGuest, forKey: "is_guest")
        coder.encode(subscriptionId, forKey: "subscription_id")
        coder.encode(subscriptionName, forKey: "subscription_name")
        coder.encode(subscriptionExpiry, forKey: "subscription_expiry")
        coder.encode(isSubscriptionActive, forKey: "is_subscription_active")
        coder.encode(weight, forKey: "weight")
        coder.encode(height, forKey: "height")
    }

    required init?(coder decoder: NSCoder) {
        self.playerTypeId = (decoder.decodeObject(forKey: "player_type_id") as? String) ?? ""
        self.email = (decoder.decodeObject(forKey: "email") as? String) ?? ""
        self.userId = (decoder.decodeObject(forKey: "user_id") as? String) ?? ""
        self.firstName = (decoder.decodeObject(forKey: "first_name") as? String) ?? ""
        self.lastName = (decoder.decodeObject(forKey: "last_name") as? String) ?? ""
        self.roleId = (decoder.decodeObject(forKey: "role_id") as? String) ?? ""
        self.picturePath = (decoder.decodeObject(forKey: "picture_path") as? String) ?? ""
        self.createdOn = (decoder.decodeObject(forKey: "created_on") as? String) ?? ""
        self.sessionToken = (decoder.decodeObject(forKey: "session_token") as? String) ?? ""
        self.active = (decoder.decodeObject(forKey: "active") as? String) ?? ""
        self.roleName = (decoder.decodeObject(forKey: "role_name") as? String) ?? ""
        self.isGuest = decoder.decodeBool(forKey: "is_guest")
        self.subscriptionId = (decoder.decodeObject(forKey: "subscription_id") as? String) ?? "1"
        self.subscriptionName = (decoder.decodeObject(forKey: "subscription_name") as? String) ?? "Free"
        self.isSubscriptionActive = decoder.decodeBool(forKey: "is_subscription_active")
        self.subscriptionExpiry = (decoder.decodeObject(forKey: "subscription_expiry" )as? String) ?? ""
        self.weight = (decoder.decodeObject(forKey: "weight") as? String) ?? ""
        self.height = (decoder.decodeObject(forKey: "height") as? String) ?? ""
        
    }
}
