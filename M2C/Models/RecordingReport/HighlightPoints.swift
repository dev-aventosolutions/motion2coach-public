//
//  HighlightPoints.swift
//  M2C
//
//  Created by Abdul Samad Butt on 17/10/2022.
//

import Foundation

struct HighlightPoints {
    
    var p1: Int?
    var p2: Int?
    var p3: Int?
    var p4: Int?
    var p5: Int?
    var p6: Int?
    var p7: Int?
    var p8: Int?
    var p9: Int?
    var p10: Int?
    
    init(json: JSON){
        self.p1 = json["P1"].int
        self.p2 = json["P2"].int
        self.p3 = json["P3"].int
        self.p4 = json["P4"].int
        self.p5 = json["P5"].int
        self.p6 = json["P6"].int
        self.p7 = json["P7"].int
        self.p8 = json["P8"].int
        self.p9 = json["P9"].int
        self.p10 = json["P10"].int
    }
}
