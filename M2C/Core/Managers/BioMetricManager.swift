//
//  BioMetricManager.swift
//  ODIE
//
//  Created by Abdul Samad on 17/02/2022.
//

import Foundation
import LocalAuthentication
import UIKit

class BioMetricManager {
    
    static let shared = BioMetricManager()
    
    private let context = LAContext()
    
    let authenticationReason = "using Bio-Metric to authenticate user"
    let evaluationPolcy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    func isBioMetricFeatureAvailable() -> Bool {
        return context.canEvaluatePolicy(evaluationPolcy, error: nil)
    }
    
    func manageBiometricAuth(callback: @escaping (_ labelTitle: String, _ buttonImage: UIImage?) -> Void) {
//        switch bioMetricType {
//        case .faceID:
//            callback("Login with Face ID", .faceId)
//            
//        case .touchID:
//            callback("Login with Touch ID", .touchId)
//            
//        default:
//            callback("", nil)
//        }
    }

    
    var bioMetricType: LABiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    func authenticate(callback: @escaping (_ success: Bool, _ message: String) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(evaluationPolcy, localizedReason: authenticationReason, reply: { (success, error) in
            
            var message = "Success"
            
            if let error = error  {
                switch error {
                case LAError.userFallback:
                    message = "should handle action when user press Enter Password"
                    
                default :
                    message = error.localizedDescription
                }
            }
            
            DispatchQueue.main.async {
                callback(success, message)
            }
        })
    }
    
}
