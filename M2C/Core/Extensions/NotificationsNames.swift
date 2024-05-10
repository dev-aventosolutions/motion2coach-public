//
//  NotificationsNames.swift
//  M2C
//
//  Created by Abdul Samad Butt on 12/09/2022.
//

import Foundation

extension NSNotification.Name {
    public static let framesExtraction: NSNotification.Name = NSNotification.Name(rawValue: "framesExtraction")
    public static let coreDataVideoDeleted: NSNotification.Name = NSNotification.Name(rawValue: "coreDataVideoDeleted")
    public static let serverVideoDeleted: NSNotification.Name = NSNotification.Name(rawValue: "serverVideoDeleted")
    public static let videoUploadStep1: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadStep1")
    public static let videoUploadStep2: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadStep2")
    public static let videoUploadStep3: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadStep3")
    public static let videoUploadStep4: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadStep4")
    
    public static let removeFrames: NSNotification.Name = NSNotification.Name(rawValue: "removeFrames")
    
    public static let videoUploadErrorStep1: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadErrorStep1")
    public static let videoUploadErrorStep2: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadErrorStep2")
    public static let videoUploadErrorStep3: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadErrorStep3")
    public static let videoUploadErrorStep4: NSNotification.Name = NSNotification.Name(rawValue: "videoUploadErrorStep4")
    
    public static let ballMoved: NSNotification.Name = NSNotification.Name(rawValue: "ballMoved")
    public static let ballNotMoved: NSNotification.Name = NSNotification.Name(rawValue: "ballNotMoved")
    public static let ballDetected: NSNotification.Name = NSNotification.Name(rawValue: "ballDetected")
    public static let ballNotDetected: NSNotification.Name = NSNotification.Name(rawValue: "ballNotDetected")
    
    public static let videoUploaded: NSNotification.Name = NSNotification.Name(rawValue: "videoUploaded")
    
    public static let serverStatus: NSNotification.Name = NSNotification.Name(rawValue: "serverStatus")
}
