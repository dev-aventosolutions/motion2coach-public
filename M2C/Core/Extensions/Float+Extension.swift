//
//  Float+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/10/2022.
//

import Foundation
import CoreMedia

extension Float{
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func toCMTime() -> CMTime{
        return CMTimeMake(value: Int64(self), timescale: 600)
    }
}
