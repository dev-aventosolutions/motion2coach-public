//
//  ServiceError.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
struct ServiceError {
    
    var status: Int = ServiceConstants.ServiceError.generic
    var message: String = ServiceConstants.ServiceError.genericError
    
}
