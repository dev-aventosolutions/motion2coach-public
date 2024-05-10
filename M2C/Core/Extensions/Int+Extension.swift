//
//  IntExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 19/05/2022.
//

import Foundation

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toCgFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func toUInt() -> UInt {
        return UInt(self)
    }
    
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}
