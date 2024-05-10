//
//  Constants.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import GoogleSignIn

//------------------------------------
// MARK: App Level
//------------------------------------
let jsonEncoder = JSONEncoder()
let userDefault = UserDefaults.standard
let signInConfig = GIDConfiguration.init(clientID: "YOUR_IOS_CLIENT_ID")

let versionNumber = "1.0.0"
let settingOptions = ["Edit Profile" , "Notifications" , "About" , "Terms & Conditions"]
let settingImages = ["1.gif" , "1.gif" , "1.gif" , "1.gif"]
let menusOptions = ["Profile", "Sessions", "Logout"]
let sideMenuImages = ["smProfile.png", "smSessions.png", "smLogout.png"]
let recordingsHistorySections = ["Today" , "Yesterday" , "Earlier This Week" , "This Month", "Long Ago"]

//------------------------------------
// MARK: Notifications
//------------------------------------

//------------------------------------
// MARK: User Data
//------------------------------------
var userData = "userData"
var isUserLogin = "isUserLogin"
var isSignedInWithGoogle = "isSignedInWithGoogle"
var isSignedInWithApple = "isSignedInWithApple"
var countOfCaptures = "countOfCaptures"
var hasPreRecordingData = "hasPreRecordingData"

//------------------------------------
// MARK: StoryBoard IDs
//------------------------------------
let SBMain = "Main"
let SBDashboard = "Dashboard"
let SBPopUps = "PopUps"
let SBSideMenu = "SideMenu"
let SBRecordings = "Recordings"
let SBCaptures = "Captures"

//------------------------------------
// MARK: VC Identifiers
//------------------------------------

let landingVCID = "LandingVC"
let loginVCID = "LoginVC"
let ForgetPasswordVCID = "ForgetPasswordVC"
let dashboardVCID = "DashboardVC"
let recordingVCID = "RecordingVC"
let recordingHistoryVCID = "RecordingHistoryVC"
let calendarVCID = "CalendarVC"
let sideMenuVCID = "SideMenuVC"
let profileVCID = "ProfileVC"
let termsOfServicesVCID = "TermsOfServicesVC"
let privacyPolicyVCID = "PrivacyPolicyVC"
let recordingDOBVCID = "RecordingDOBVC"
let recordingGenderVCID = "RecordingGenderVC"
let recordingWeightVCID = "RecordingWeightVC"
let recordingPlayerTypeVCID = "RecordingPlayerTypeVC"
let dashbaordOptionsVCID = "DashbaordOptionsVC"
let capturesOptionsVCID = "CapturesOptionsVC"
let scanFirstVCID = "ScanFirstVC"
let scanSecondVCID = "ScanSecondVC"
let liveVCID = "LiveVC"
let visualizationVCID = "VisualizationVC"
let reportVCID = "ReportVC"
let recordingDownTheLineVCID = "RecordingDownTheLineVC"
let recordingDownTheLineImageVCID = "RecordingDownTheLineImageVC"
let recordingFaceOnVCID = "RecordingFaceOnVC"
let recordingFaceOnImageVCID = "RecordingFaceOnImageVC"
let recordSwingOptionsVCID = "RecordSwingOptionsVC"
let scanVisualizationVCID = "ScanVisualizationVC"
let gifViewControllerID = "GifViewController"

enum PoseConstants {
  static let circleViewAlpha: CGFloat = 0.7
  static let rectangleViewAlpha: CGFloat = 0.3
  static let shapeViewAlpha: CGFloat = 0.3
  static let rectangleViewCornerRadius: CGFloat = 10.0
  static let maxColorComponentValue: CGFloat = 255.0
  static let originalScale: CGFloat = 1.0
  static let bgraBytesPerPixel = 4
  static let circleViewIdentifier = "MLKit Circle View"
  static let lineViewIdentifier = "MLKit Line View"
  static let rectangleViewIdentifier = "MLKit Rectangle View"
}


class AppConstants{
    static let arrUnits: [String] = ["Kgs", "lbs"]
}

class UDKey {
    static let userToken = "USER_SESSION_TOKEN"
    static let savedUser = "SAVED_USER"
    static let savedUserEmail = "SAVED_USER_EMAIL"
    static let savedUserPassword = "SAVED_USER_PASSWORD"
    static let showPreviewGif = "SHOW_PREVIEW_GIF"
    static let showReportGif = "SHOW_REPORT_GIF"
    static let isRecordingWeightAdded = "RECORDING_WEIGHT_ADDED"
    static let videoWeight = "VIDEO_WEIGHT"
    static let videoHeight = "VIDEO_HEIGHT"
    static let videoSettings = "VIDEO_SETTINGS"
}

struct Messages {
    
    static let noInternet = "No Internet Connection"
    static let requestTimeOut = "Request Timed Out"
    static let error = "Error"
    static let serviceFailure = "Service Failure"
}

struct VideoSettings {
    
    static let frameRates = ["120 fps", "60 fps", "30 fps"]
    static let numOfVideos = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    static let arrIsoFrontCam: [String] = ["25", "50", "250", "350"]
    static let arrShutterSpeedFrontCam: [String] = ["30", "60", "1500", "3500"]
    
    static let arrIsoRearCam: [String] = ["25", "50", "250", "450", "800"]
    static let arrShutterSpeedRearCam: [String] = ["30", "60", "1500", "4500", "8000"]
}

class SideMenuConstants{
    static let arrSideMenu: [SideMenu] = [SideMenu(title: "My Dashbaord", imageName: "sm.mydashboard"),SideMenu(title: "Strikers", imageName: "smStrikerCoach"), SideMenu(title: "Settings", imageName: "sm.settings")]
}

class StoryboardRef {
    static let general: UIStoryboard = UIStoryboard(name: "General", bundle: nil)
    static let recordings: UIStoryboard = UIStoryboard(name: "Recordings", bundle: nil)
    static let dashboard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
    static let auth: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let captures: UIStoryboard = UIStoryboard(name: "Captures", bundle: nil)
}

//class RecordingReportConstants{
////    static let arrReport: [RecordingReport] = [
//        RecordingReport(title: "Start to Impact", reading: "", unit: "s", bottomText: "Corridor 1 - 1.5 s", color: .reportBlue),
//        RecordingReport(title: "Backswing", reading: "", unit: "s", bottomText: "Corridor 0.75 - 1.5 s", color: .reportYellow),
//        RecordingReport(title: "Downswing", reading: "", unit: "s", bottomText: "Corridor 0.25 - 0.35 s", color: .reportGreen),
//        RecordingReport(title: "Tempo", reading: "", unit: "", bottomText: "Corridor 2.5 - 3.5 :1", color: .reportBlue),
//        RecordingReport(title: "Handpath BS", reading: "", unit: "cm", bottomText: "", color: .reportYellow),
//        RecordingReport(title: "Handpath DS", reading: "", unit: "cm", bottomText: "", color: .reportGreen),
//        RecordingReport(title: "Max. Hand Speed", reading: "", unit: "", bottomText: "Over 14 mph", color: .reportBlue),
//        RecordingReport(title: "Max. UT Turn", reading: "", unit: "", bottomText: "Corridor -102  to -85", color: .reportYellow),
//        RecordingReport(title: "Max. Pelvis Turn", reading: "", unit: "", bottomText: "Corridor -55 to - 38", color: .reportGreen)
//
//    static let arrReport: [[RecordingReport]] = [[], [], [], [], [], [], [], [], []]
//}

class DateFormats{
    static let prospectHitlistLastUpdated = "dd-MMMM-yyyy, hh:mm aa"
    static let timeFormat12Hour = "hh:mm aa"
    static let yearMonthDay = "YYYY-MM-dd" //"2022-06-24"
    static let DateTimeFormatReceiptStandard = "MMM dd, yyyy - hh:mm a"
    static let DateTimeFormatStandard = "yyyy-MM-dd HH:mm:ss"
    static let DateTimeFormatStandardGeneral = "yyyy-MM-dd HH:mm:ssZ"
    static let hispDateTimeFormatStandard = "yyyyMMdd HH:mm:ss"
    static let DateTimeFormatStandard2 = "MM/dd/yyyy hh:mm a"
    static let DateTimeFormatStandard3 = "MM/dd/yyyy HH:mm"
    static let DateTimeFormatStandard4 = "MM/dd/yyyy hh:mm:ss"
    static let DateTimeFormatStandardLong = "yyyy-MM-dd'T'HH:mm:ss"
    static let assessmentCompletionDateAndTime = "yyyy-MM-dd HH:mm"
    static let DateTimeFormatStandardLongZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let DateTimeFormatStandardLongAM = "yyyy-MM-dd'T'hh:mm:ss aa"
    static let DateTimeFormatStandardLongMiliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let DateTimeFormatStandardWithTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DateTimeFormatStandardWithTimeZone1 = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let DateTimeFormatTimeShort = "HH:mm:ss.SSSZ"
    static let DateTimeFormatForServer = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let DateTimeFormatForServerOLD = "dd-MMM-yyyy hh:mm aa"
    static let monthDayYear = "MM/dd/yyyy"
    static let dayMonthYear = "dd/MM/yyyy"
    static let DateFormatStandardDDMMYYYY = "dd/MM/yyyy"
    static let DateFormatDotStandard = "dd.MM.yyyy"
    static let DateFormatSpaceStandard = "dd MMM, yyyy"
    static let DateFormatSpaceStandardWithTimeSpace = "dd MMM, yyyy hh:mm aa"
    static let DateFormatSpaceStandardWithTime = "dd MMM, yyyy - hh:mm aa"
    static let DateFormatStandard2 = "yyyy-MM-dd"
    static let DateFormatYearOnly = "YYYY"
    static let DateFormatMonthWithYear = "MMMM YYYY"
    static let DateFormatMonthWithDay = "MMM dd"
    static let DateFormatMonthWithDayHour = "MMM dd @haa"
    static let DateFormatTodayWithTime = "'Today' hh:mm aa"
    static let DateFormatYesterdayWithTime = "'Yesterday' hh:mm aa"
    static let DateFormatMonthDayNameYear = "EEE, MMM d, hh:mm aa"
    static let DateFormatMonthDayNameYearLong = "EEEE, MMMM d, yyyy - hh:mm aa"
    static let DateFormatDayNameYear = "EEE, dd/MM/yyyy, hh:mm aa"
    static let DateFormatMonthDayYear = "MMM d, yyyy, hh:mm aa"
    static let DateFormatMonthOnly = "MMMM"
    static let DateFormatMonthShort = "MMM"
    static let DateFormatMonthNumber = "MM"
    static let DateFormatDayOnly = "dd"
    static let DateFormatShort = "MMM d, yyyy"
    static let DateFormatShort2 = "dd MMM, yyyy"
    static let DateFormatShort3 = "dd MMMM, yyyy"
    static let hourMinSec24HourFormat = "HH:mm:ss"
    static let hourMin = "HH:mm"
    static let TimeFormatHourOnly = "haa"
    static let DateTimeEmptyString = "0000-00-00 00:00:00"
}


class RecordingReportConstants {
    
    static var arrReport: [RecordingReport] = [
        RecordingReport(title: "Start to Impact", reading: "", unit: "", bottomText: "sec", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Backswing", reading: "", unit: "", bottomText: "sec", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Downswing", reading: "", unit: "", bottomText: "sec", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Tempo", reading: "", unit: "", bottomText: "", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Handpath BS", reading: "", unit: "", bottomText: "cm", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Handpath DS", reading: "", unit: "", bottomText: "cm", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Max H. Speed (P4-P7)", reading: "", unit: "", bottomText: "mph", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Shoulder Turn(P4)", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Max. Pelvis Turn", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false)]
    
    static var arrEmptyReport: [RecordingReport] = [
        RecordingReport(title: "Start to Impact", reading: "", unit: "", bottomText: "sec", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Backswing", reading: "", unit: "", bottomText: "sec", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Downswing", reading: "", unit: "", bottomText: "sec", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Tempo", reading: "", unit: "", bottomText: "", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Handpath BS", reading: "", unit: "", bottomText: "cm", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Handpath DS", reading: "", unit: "", bottomText: "cm", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Max H. Speed (P4-P7)", reading: "", unit: "", bottomText: "mph", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Shoulder Turn(P4)", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Max. Pelvis Turn", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false)]
    
    static var arrEmptyDescription: [RecordingReport] = [
        RecordingReport(title: "Head Turn", reading: "", unit: "", bottomText: "degree", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Head Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Head Bend", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Shoulder Turn", reading: "", unit: "", bottomText: "degree", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Shoulder Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Shoulder Bend", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false),
        RecordingReport(title: "Pelvis Turn", reading: "", unit: "", bottomText: "degree", color: .reportBlue, isLocked: false),
        RecordingReport(title: "Pelvis Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false),
        RecordingReport(title: "Pelvis Bend", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false)]
    
    static var arrHighlights: [[RecordingReport]] = [[ ]]
    
}

func getUUID() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? ""
}
