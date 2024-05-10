//
//  Global.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit

class Global {
    class var shared : Global {
        
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    var allCaptures = [CaptureModel]()
    var selectedCapture = CaptureModel()
    var livePhoto: UIImage = UIImage()
    var extractedFrames: [UIImage] = [UIImage]()
    var loginUser: LoginUser?
    var selectedOrientation: PlayerOrientation?
    var selectedSwingType: SwingType?
    var selectedClubType: ClubType?
    var selectedStriker: Striker?
}
var serverRequest = Services()
