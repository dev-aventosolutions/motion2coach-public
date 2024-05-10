//
//  PHAsset+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 28/07/2022.
//

import Foundation
import Photos
import UIKit

extension PHAsset{
    
    func toUIimage() -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageDataAndOrientation(for: self, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}
