//
//  UserDetails.swift
//  M2C
//
//  Created by Abdul Samad Butt on 29/08/2022.
//

import Foundation
import UIKit

class UserDetails {
    
    var image = UIImage()
    var id: Int?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var email: String?
    var contactNumber: String?
    var picture: String?
    var registrationDate: String?
    var hcp: String?
    var createdAt: String?
    var updatedAt: String?
    var addressId: String?
    var address: String?
    var houseNo: String?
    var postCode: String?
    var cityId: String?
    var city: String?
    var stateId: String?
    var state: String?
    var countryId: String?
    var country: String?
    var genderId: String?
    var gender: String?
    var roleId: String?
    var role: String?
    var playerTypeId: String?
    var playerType: String?
    var street: String?
    var subscriptionExpiry: String?
    var subscriptionId: String?
    var subscriptionName: String?
    var isSubscriptionActive: Bool = false
    var isGuest: Bool = false
    
    init(){}
    
    init(json: JSON){
        self.id = json["id"].intValue
        self.firstName = json["firstName"].stringValue
        self.lastName = json["lastName"].stringValue
        self.dateOfBirth = json["dateOfBirth"].stringValue
        self.email = json["email"].stringValue
        self.contactNumber = json["contactNumber"].stringValue
        self.picture = json["picture"].stringValue
        self.registrationDate = json["registrationDate"].stringValue
        self.hcp = json["HCP"].stringValue
        self.createdAt = json["createdAt"].stringValue
        self.updatedAt = json["updatedAt"].stringValue
        self.addressId = json["addressId"].stringValue
        self.address = json["address"].stringValue
        self.houseNo = json["houseNo"].stringValue
        self.postCode = json["postCode"].stringValue
        self.cityId = json["cityId"].stringValue
        self.city = json["city"].stringValue
        self.stateId = json["stateId"].stringValue
        self.state = json["state"].stringValue
        self.countryId = json["countryId"].stringValue
        self.country = json["country"].stringValue
        self.genderId = json["genderId"].stringValue
        self.gender = json["gender"].stringValue
        self.roleId = json["roleId"].stringValue
        self.role = json["role"].stringValue
        self.playerTypeId = json["playerTypeId"].stringValue
        self.playerType = json["playerType"].stringValue
        self.street = json["street"].stringValue
        self.subscriptionId = json["subscriptionId"].stringValue
        self.subscriptionName = json["subscriptionName"].stringValue
        self.subscriptionExpiry = json["subscriptionExpiry"].stringValue
        self.isSubscriptionActive = json["isSubscriptionActive"].boolValue
        self.isGuest = json["guestUser"].boolValue
    }
}
