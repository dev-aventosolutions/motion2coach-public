//
//  AppTargets.swift
//  M2C
//
//  Created by Abdul Samad Butt on 30/01/2023.
//

import Foundation

//MARK:- App Targets
public enum AppTargets {
    case m2c
    case dev
    case internalTesters
}

extension AppTargets {
    var scheme: String {
        switch self {
        case .m2c:
             return "M2C"
        case .dev:
            return "M2C Dev"
        case .internalTesters:
            return "M2C Internal"
        }
    }
}

//MARK:- Selected Targets

public enum SelectedTarget {
    case enviornment
}

extension SelectedTarget {
    var scheme: String {
        switch self {
        case .enviornment:
            
            if let env = Bundle.main.object(forInfoDictionaryKey: "CFBundleName"){
                print(env)
                return env as! String
            }else{
                return ""
            }
                
                
//            guard let env =  Bundle.main.infoDictionary?["TARGET_NAME"] as? String else { return "" }
//            return env
        }
    }
}
