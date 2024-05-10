//
//  ServiceConstants.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
class ServiceConstants {
    
    
    struct ServiceError {
        static let timeOutInterval: TimeInterval = 30
        
        static let error = "Error"
        static let internetNotAvailable = "Internet Not Available"
        static let pleaseTryAgain = "Please Try Again."
        
        static let generic = 4000
        //        static let genericError = "Please Try Again."
        static let genericError = "Can't connect to server."
        
        static let validationErrorMessage = "All missing fields are required."
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available"
        static let serverError = "Server Not Availabe, Please Try Later."
        
        static let timeout = 4001
        static let timeoutError = "Can't connect to Server."//"Network Time Out, Please Try Again."
        
        static let login = 4003
        static let loginMessage = "Unable To Login"
        static let loginError = "Please Try Again."
        
        static let internet = 4004
        static let internetError = "Internet Not Available"
        
        static let sessionExpiredStatus = 550
        static let sessionExpiredMessage = "Your session has been expired"
        
    }
    
}
