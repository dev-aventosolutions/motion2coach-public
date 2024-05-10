//
//  CIImage+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 05/12/2022.
//

import Foundation
import UIKit

extension CIImage{
    
    func toCgImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}
