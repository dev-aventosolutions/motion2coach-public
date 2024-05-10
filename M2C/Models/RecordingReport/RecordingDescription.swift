//
//  RecordingDescription.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 25.10.22.
//

import Foundation

class RecordingDescription{
    
    var arrDescription = [[RecordingReport]]()
    //head
    var headTurn: [String] = [String]()
    var headTilt: [String] = [String]()
    var headBend: [String] = [String]()
    //pelvis
    var pelvisTurn: [String] = [String]()
    var pelvisTilt: [String] = [String]()
    var pelvisBend: [String] = [String]()
    //ut
    var utTurn: [String] = [String]()
    var utTilt: [String] = [String]()
//    var utBend: [String] = [String]()
    var handSpeed: [String] = [String]()
    var verticalForce: [String] = [String]()
//
//    var handThrustLeft: [String] = [String]()
//    var handSwayLeft: [String] = [String]()
//    var handLiftLeft: [String] = [String]()
//    var elbowAngleLeft: [String] = [String]()
//    var elbowAngleRight: [String] = [String]()
//    var xFactor: [String] = [String]()
    
    init(json: JSON) {
        //head
        let arrHeadTurn = json["head_turn"].arrayValue
        let arrHeadTilt = json["head_tilt"].arrayValue
        let arrHeadBend = json["head_bend"].arrayValue
        //pelvis
        let arrPrlvisTurn = json["pelvis_turns"].arrayValue
        let arrPrlvisTilt = json["pelivs_tilts"].arrayValue
        let arrPrlvisBend = json["pelvis_bends"].arrayValue
        //ut
        let arrUtTurn = json["ut_turns"].arrayValue
        let arrUtTilt = json["ut_tilts"].arrayValue
        let arrHandSpeed = json["hand_speed"].arrayValue
//        let arrVerticalForce = json["Fz_t_est"].arrayValue
        let arrVerticalForce = json["Wt_percent"].arrayValue
//        let arrUtBend = json["ut_bends"].arrayValue
        
        //head
        arrHeadTurn.forEach({ self.headTurn.append($0.stringValue) })
        arrHeadTilt.forEach({ self.headTilt.append($0.stringValue) })
        arrHeadBend.forEach({ self.headBend.append($0.stringValue) })
        //pelvis
        arrPrlvisTurn.forEach({ self.pelvisTurn.append($0.stringValue) })
        arrPrlvisTilt.forEach({ self.pelvisTilt.append($0.stringValue) })
        arrPrlvisBend.forEach({ self.pelvisBend.append($0.stringValue) })
        //Ut
        arrUtTurn.forEach({ self.utTurn.append($0.stringValue) })
        arrUtTilt.forEach({ self.utTilt.append($0.stringValue) })
        arrHandSpeed.forEach({ self.handSpeed.append($0.stringValue) })
        arrVerticalForce.forEach({ self.verticalForce.append($0.stringValue) })
        
        // Run the loops
        for (index) in self.headTurn.enumerated() {
            
//            print(index.offset)
            var arrReport: [RecordingReport] = [RecordingReport(title: "Head Turn", reading: headTurn[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportBlue, isLocked: false)
            ]
            
            // For Head Tilt
            if headTilt.isEmpty{
                arrReport.append(RecordingReport(title: "Head Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Head Tilt", reading: headTilt[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }
            
            // For Head Bend
            if headBend.isEmpty{
                arrReport.append(RecordingReport(title: "Head Bend", reading: "", unit: "", bottomText: "degree", color: .reportGreen, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Head Bend", reading: headBend[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportGreen, isLocked: false))
            }
            
            // For Shoulder Turn
            if utTurn.isEmpty{
                arrReport.append(RecordingReport(title: "Shoulder Turn", reading: "", unit: "", bottomText: "degree", color: .reportBlue, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Shoulder Turn", reading: utTurn[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportBlue, isLocked: false))
            }
            
            // For Shoulder Tilt
            if utTilt.isEmpty{
                arrReport.append(RecordingReport(title: "Shoulder Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Shoulder Tilt", reading: utTilt[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }
            
            // For Hand Speed
            if handSpeed.isEmpty{
                arrReport.append(RecordingReport(title: "Hand Speed", reading: "", unit: "", bottomText: "mph", color: .reportGreen, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Hand Speed", reading: handSpeed[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "mph", color: .reportGreen, isLocked: false))
            }
            
            // For Pelvis Turns
            if pelvisTurn.isEmpty{
                arrReport.append(RecordingReport(title: "Pelvis Turn", reading: "", unit: "", bottomText: "degree", color: .reportBlue, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Pelvis Turn", reading: pelvisTurn[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportBlue, isLocked: false))
            }
            
            // For Pelvis Tilt
            if pelvisTilt.isEmpty{
                arrReport.append(RecordingReport(title: "Pelvis Tilt", reading: "", unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Pelvis Tilt", reading: pelvisTilt[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            }
            
            // For Vertical Force
            if verticalForce.isEmpty{
                arrReport.append(RecordingReport(title: "Vertical Force", reading: "", unit: "", bottomText: "weight %", color: .reportGreen, isLocked: false))
            }else{
                arrReport.append(RecordingReport(title: "Vertical Force", reading: verticalForce[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "weight %", color: .reportGreen, isLocked: false))
            }
            
//            arrReport.append(RecordingReport(title: "Shoulder Bend", reading: utBend[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportGreen, isLocked: true))
//            arrReport.append(RecordingReport(title: "Pelvis Bend", reading: pelvisBend[index.offset].toDouble().toString(decimalPlaces: 2), unit: "", bottomText: "degree", color: .reportGreen, isLocked: false))
            
            self.arrDescription.append(arrReport)
        }
        
//        self.arrDescription.removeFirst()
    }
}
