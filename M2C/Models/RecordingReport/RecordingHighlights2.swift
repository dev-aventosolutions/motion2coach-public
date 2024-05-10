//
//  RecordingHighlights.swift
//  M2C
//
//  Created by Abdul Samad Butt on 13/10/2022.
//

import Foundation

class RecordingHighlights2{
    
    var arrHighlights2 = [[RecordingReport]()]
    var headTurn: [String] = [String]()
    var headTilt: [String] = [String]()
    var headBend: [String] = [String]()
    var handThrustLeft: [String] = [String]()
    var handSwayLeft: [String] = [String]()
    var handLiftLeft: [String] = [String]()
    var elbowAngleLeft: [String] = [String]()
    var elbowAngleRight: [String] = [String]()
    var xFactor: [String] = [String]()
    
    init(json: JSON) {
        let arrHeadTurn = json["head_turn_deg_List"].arrayValue
        let arrHeadTilt = json["head_tilt_deg_List"].arrayValue
        let arrHeadBend = json["head_bend_deg_List"].arrayValue
        let arrHandThrustLeft = json["hand_l_thrust"].arrayValue
        let arrHandSwayLeft = json["hand_l_sway"].arrayValue
        let arrHandLiftLeft = json["hand_l_lift"].arrayValue
        let arrElbowAngleLeft = json["elbow_angle_l_deg"].arrayValue
        let arrElbowAngleRight = json["elbow_angle_r_deg"].arrayValue
        let arrXFactor = json["x_factor"].arrayValue
        
        arrHeadTurn.forEach({ self.headTurn.append($0.stringValue) })
        arrHeadTilt.forEach({ self.headTilt.append($0.stringValue) })
        arrHeadBend.forEach({ self.headBend.append($0.stringValue) })
        arrHandThrustLeft.forEach({ self.handThrustLeft.append($0.stringValue) })
        arrHandSwayLeft.forEach({ self.handSwayLeft.append($0.stringValue) })
        arrHandLiftLeft.forEach({ self.handLiftLeft.append($0.stringValue) })
        arrElbowAngleLeft.forEach({ self.elbowAngleLeft.append($0.stringValue) })
        arrElbowAngleRight.forEach({ self.elbowAngleRight.append($0.stringValue) })
        arrXFactor.forEach({ self.xFactor.append($0.stringValue) })
        
        // Run the loops
        for (index) in self.headTurn.enumerated() {
            var arrReport: [RecordingReport] = [RecordingReport(title: "Head Turn", reading: headTurn[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportBlue, isLocked: false)
            ]
            arrReport.append(RecordingReport(title: "Head Tilt", reading: headTilt[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            arrReport.append(RecordingReport(title: "Head Bend", reading: headBend[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportGreen, isLocked: false))
            arrReport.append(RecordingReport(title: "Hand Thrust(Left)", reading: handThrustLeft[index.offset].displayCharacters(n: 3), unit: "", bottomText: "cm", color: .reportBlue, isLocked: false))
            arrReport.append(RecordingReport(title: "Hand Sway(Left)", reading: handSwayLeft[index.offset].displayCharacters(n: 3), unit: "", bottomText: "cm", color: .reportYellow, isLocked: false))
            arrReport.append(RecordingReport(title: "Hand Lift(Left)", reading: handLiftLeft[index.offset].displayCharacters(n: 3), unit: "", bottomText: "cm", color: .reportGreen, isLocked: false))
            arrReport.append(RecordingReport(title: "Elbow Angle(Left)", reading: elbowAngleLeft[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportBlue, isLocked: false))
            arrReport.append(RecordingReport(title: "Elbow Angle(Right)", reading: elbowAngleRight[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportYellow, isLocked: false))
            arrReport.append(RecordingReport(title: "X Factor", reading: xFactor[index.offset].displayCharacters(n: 3), unit: "", bottomText: "degree", color: .reportGreen, isLocked: false))
            
            self.arrHighlights2.append(arrReport)
        }
        
        self.arrHighlights2.removeFirst()
    }
}
