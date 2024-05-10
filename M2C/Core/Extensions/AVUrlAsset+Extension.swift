//
//  AVUrlAsset.swift
//  M2C
//
//  Created by Abdul Samad Butt on 12/10/2022.
//

import Foundation
import AVKit

extension AVURLAsset {
    
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)

        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}
