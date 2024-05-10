//
//  ServiceUrl.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation

class ServiceUrls {
    
    //------------------------------------
    // MARK: BaseUrl
    //------------------------------------
    
    static var baseUrlM2c: String {
        if SelectedTarget.enviornment.scheme == AppTargets.m2c.scheme {
            return "https://api.motion2coach.com/"
        } else if SelectedTarget.enviornment.scheme == AppTargets.dev.scheme {
            return "https://api.motion2coach.com/"
        } else if SelectedTarget.enviornment.scheme == AppTargets.internalTesters.scheme {
            return "https://api.motion2coach.com/"
        } else {
            return "https://api.motion2coach.com/sandbox/"
        }
    }
    
    
    static var baseUrlBioMechanics: String {
        if SelectedTarget.enviornment.scheme == AppTargets.m2c.scheme {
            return "https://cg3vodhur5.execute-api.eu-central-1.amazonaws.com/dev/"
        } else if SelectedTarget.enviornment.scheme == AppTargets.dev.scheme {
            return "https://cg3vodhur5.execute-api.eu-central-1.amazonaws.com/dev/"
        } else if SelectedTarget.enviornment.scheme == AppTargets.internalTesters.scheme {
            return "https://cg3vodhur5.execute-api.eu-central-1.amazonaws.com/dev/"
        } else {
            return "https://qrg720b0g4.execute-api.eu-central-1.amazonaws.com/sandbox/"
        }
    }
    
    static var socketUrl: String {
        if SelectedTarget.enviornment.scheme == AppTargets.m2c.scheme {
            return "wss://w4v6un8ey8.execute-api.eu-west-1.amazonaws.com/production"
        } else if SelectedTarget.enviornment.scheme == AppTargets.dev.scheme {
            return "wss://w4v6un8ey8.execute-api.eu-west-1.amazonaws.com/production"
        } else if SelectedTarget.enviornment.scheme == AppTargets.internalTesters.scheme {
            return "wss://w4v6un8ey8.execute-api.eu-west-1.amazonaws.com/production"
        } else {
            return "wss://9ieiiu62hg.execute-api.eu-west-1.amazonaws.com/sandbox"
        }
    }
    
    
    static var UserToken: String {
        return ""
        
    }
    
    //------------------------------------
    // MARK: Api Urls
    //------------------------------------
    
    struct URLs {
        static let loginUrl = "user/login"
        static let logout = "user/logout"
        static let signUp = "user/register"
        static let checkEmail = "user/email"
        static let resetter = "user/password/resetter"
        static let resetPass = "user/password/reset"
        static let getOrientations = "getOrientations"
        static let getPlayerTypes = "user/getPlayerTypes"
        static let getMasterData = "user/masterData"
        static let getHighlights =  "files/highlights"
        static let getHighlights2 =  "files/highlights2"
        static let getDescription =  "files/description"
        static let getVideos = "user/videos/get"
        static let deleteVideos = "user/videos/delete"
        static let getHighlightPositions =  "files/getPositions"
        static let updatePositions =  "files/updatePositions"
        static let getOverlayUrl =  "user/getUrl"
        static let kinematicAnalysis =  "user/kinematicAnalysisReport"
        static let uploadMedia =  "user/uploadMedia"
        static let activateUser =  "user/activateUser"
        static let resendOtp =  "user/sendVerification/token"
        static let addVideo = "user/videos/add"
        static let addScannedImage = "user/scans/add"
        static let getRoles = "user/roles"
        static let getCountries = "user/countries"
        static let getCities = "user/citiesByCountry"
        static let getGenders = "user/genders"
        static let updateUser = "user/updateUser"
        static let getUser = "user/getUser"
        static let changePassword = "user/changeUserPassword"
        static let getAllowedUser = "user/videos/getAllowedUsers"
        static let inviteUser = "user/videos/inviteUser"
        static let removeCoach = "user/videos/removeCoach"
        static let acceptInvite = "user/videos/acceptInvite"
        static let inviteGuest = "user/guest/invite"
        static let deleteUser = "user/deleteUser"
        static let getUserSubscription = "user/getUserSubscription"
    }
    
}
