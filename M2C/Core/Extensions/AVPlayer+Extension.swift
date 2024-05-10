//
//  AVPlayer+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 06/12/2022.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
