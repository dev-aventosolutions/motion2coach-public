//
//  SeekSliderData.swift
//  M2C
//
//  Created by Abdul Samad Butt on 28/10/2022.
//

import Foundation
import UIKit

class SeekSliderData{
    
    var arrReport: [RecordingReport]?
    var frameImage: UIImage?
    
    init(arrReport: [RecordingReport]? = nil, frameImage: UIImage? = nil) {
        self.arrReport = arrReport
        self.frameImage = frameImage
    }
}
