//
//  RecordingReport.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/09/2022.
//

import Foundation
import UIKit

class RecordingReport{
    
    var title: String = ""
    var reading: String = ""
    var unit: String = ""
    var bottomText: String = ""
    var color: UIColor?
    var isLocked: Bool = false
    
    init(title: String, reading: String, unit: String, bottomText: String, color: UIColor, isLocked: Bool){
        self.title = title
        self.reading = reading
        self.unit = unit
        self.bottomText = bottomText
        self.color = color
        self.isLocked = isLocked
    }
    
}
