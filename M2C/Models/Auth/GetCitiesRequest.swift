//
//  GetCitiesRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 27/07/2022.
//

import Foundation

class GetCitiesRequest{
    
    static let shared  = GetCitiesRequest()
    
    var countryId: String!
    
    func returnCitiesParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "countryId" : countryId!
        ]
        return params
    }
}
