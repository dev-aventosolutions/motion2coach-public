//
//  NSObject.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}
