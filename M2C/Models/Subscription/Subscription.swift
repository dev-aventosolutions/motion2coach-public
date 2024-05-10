//
//  Subscription.swift
//  M2C
//
//  Created by Fenris GMBH on 13/02/2023.
//

import Foundation

class Subscription{
    
    var url: String = ""
    var expiry: String = ""
    var id: String = ""
    var subscriptionId: String = ""
    
    init(json: JSON){
        self.url = json["url"].stringValue
        self.expiry = json["expiry"].stringValue
        self.id = json["id"].stringValue
        self.subscriptionId = json["subscriptionId"].stringValue
    }
    
}
