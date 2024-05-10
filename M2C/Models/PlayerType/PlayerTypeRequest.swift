//
//  PlayerTypeRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/09/2022.
//

import Foundation

class PlayerTypeRequest{
    
    static let shared = PlayerTypeRequest()
    
    var loggedUserId: String = ""
    
    func returnPlayerTypeRequestParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "loggedUserId" : loggedUserId
        ]
        return params
    }
}
