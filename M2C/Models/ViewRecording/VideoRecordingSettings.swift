//
//  VideoSettings.swift
//  M2C
//
//  Created by Abdul Samad Butt on 15/08/2022.
//

import Foundation

class VideoRecordingSettings: NSObject, NSSecureCoding{
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var isCountinous: Bool = false
    var isManualDetect: Bool = false
    var numOfRecordings: Int = 1
    var frameRate: Int = 120
    var shutterSpeedRearCam: Int = 30
    var shutterSpeedFrontCam: Int = 30
    var isoRearCam: Int = 25
    var isoFrontCam: Int = 25
    
    override init(){
        self.isCountinous = false
        self.isManualDetect = false
        self.numOfRecordings = 1
        self.frameRate = 120
        self.shutterSpeedRearCam = 30
        self.shutterSpeedFrontCam = 30
        self.isoRearCam = 500
        self.isoFrontCam = 25
    }
    
    init(isContinous: Bool, numOfRecordings: Int, frameRate: Int, isoFrontCam: Int, shutterSpeedFrontCam: Int, isoRearCam: Int, shutterSpeedRearCam: Int, isManualDetect: Bool){
        
        self.isCountinous = isContinous
        self.numOfRecordings = numOfRecordings
        self.frameRate = frameRate
        self.shutterSpeedFrontCam = shutterSpeedFrontCam
        self.shutterSpeedRearCam = shutterSpeedRearCam
        self.isoRearCam = isoRearCam
        self.isoFrontCam = isoFrontCam
        self.isManualDetect = isManualDetect
        super.init()        // call NSObject's init method
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(isCountinous, forKey: "isCountinous")
        coder.encode(numOfRecordings, forKey: "numOfRecordings")
        coder.encode(frameRate, forKey: "frameRate")
        coder.encode(shutterSpeedRearCam, forKey: "shutterSpeedRearCam")
        coder.encode(shutterSpeedFrontCam, forKey: "shutterSpeedFrontCam")
        coder.encode(isoRearCam, forKey: "isoRearCam")
        coder.encode(isoFrontCam, forKey: "isoFrontCam")
        coder.encode(isManualDetect, forKey: "isManualDetect")
    }

    required init?(coder decoder: NSCoder) {
        self.isCountinous = decoder.decodeBool(forKey: "isCountinous")
        self.isManualDetect = decoder.decodeBool(forKey: "isManualDetect")
        self.numOfRecordings = decoder.decodeInteger(forKey: "numOfRecordings")
        self.frameRate = decoder.decodeInteger(forKey: "frameRate")
        self.shutterSpeedRearCam = decoder.decodeInteger(forKey: "shutterSpeedRearCam")
        self.shutterSpeedFrontCam = decoder.decodeInteger(forKey: "shutterSpeedFrontCam")
        self.isoRearCam = decoder.decodeInteger(forKey: "isoRearCam")
        self.isoFrontCam = decoder.decodeInteger(forKey: "isoFrontCam")
        
    }
}

enum FrameRate: CGFloat{
    case fps30 = 30
    case fps60 = 60
    case fps120 = 120
    case fps240 = 240
    case fps360 = 360
}
