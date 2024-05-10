//
//  AVAsset+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 21/09/2022.
//

import AVKit
import Foundation
import Darwin
import AVFoundation

extension AVAsset {
    
    enum Orientation {
        case up, down, right, left
    }
    
    func orientation(for track: AVAssetTrack) -> Orientation {
        let t = track.preferredTransform
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {       // Portrait
            return .up
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {   // PortraitUpsideDown
            return .down
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {    // LandscapeRight
            return .right
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {   // LandscapeLeft
            return .left
        } else {
            return .up
        }
    }
    
    func cropVideoTrack(at index: Int, cropRect: CGRect, outputURL: URL, completion: @escaping (String) -> ()) {
        
        let videoTrack = tracks(withMediaType: .video)[index]
        let originalSize = videoTrack.naturalSize
        let trackOrientation = orientation(for: videoTrack)
        let cropRectIsPortrait = cropRect.width <= cropRect.height
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = cropRect.size
        videoComposition.frameDuration = CMTime(value: 1, timescale: 600)
        let instruction = AVMutableVideoCompositionInstruction()
        //    instruction.timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: 60, preferredTimescale: 30))
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        var finalTransform: CGAffineTransform = CGAffineTransform.identity // setup a transform that grows the video, effectively causing a crop
        if trackOrientation == .up {
            if !cropRectIsPortrait { // center video rect vertically
                finalTransform = finalTransform
                    .translatedBy(x: originalSize.height, y: -(originalSize.width - cropRect.size.height) / 2)
                    .rotated(by: CGFloat(90.0 * Double.pi / 180))
            } else {
                finalTransform = finalTransform
                    .rotated(by: CGFloat(90.0 * Double.pi / 180))
                    .translatedBy(x: 0, y: -originalSize.height)
            }
        } else if trackOrientation == .down {
            if !cropRectIsPortrait { // center video rect vertically (NOTE: did not test this case, since camera doesn't support .portraitUpsideDown in this app)
                finalTransform = finalTransform
                    .translatedBy(x: -originalSize.height, y: (originalSize.width - cropRect.size.height) / 2)
                    .rotated(by: CGFloat(-90.0 * Double.pi / 180))
            } else {
                finalTransform = finalTransform
                    .rotated(by: CGFloat(-90.0 * Double.pi / 180))
                    .translatedBy(x: -originalSize.width, y: -(originalSize.height - cropRect.size.height) / 2)
            }
        } else if trackOrientation == .right {
            if cropRectIsPortrait {
                finalTransform = finalTransform.translatedBy(x: -(originalSize.width - cropRect.size.width) / 2, y: 0)
            } else {
                finalTransform = CGAffineTransform.identity
            }
        } else if trackOrientation == .left {
            if cropRectIsPortrait { // center video rect horizontally
                finalTransform = finalTransform
                    .rotated(by: CGFloat(-180.0 * Double.pi / 180))
                    .translatedBy(x: -originalSize.width + (originalSize.width - cropRect.size.width) / 2, y: -originalSize.height)
            } else {
                finalTransform = finalTransform
                    .rotated(by: CGFloat(-180 * Double.pi / 180))
                    .translatedBy(x: -originalSize.width, y: -originalSize.height)
            }
        }
        transformer.setTransform(finalTransform, at: .zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        let exporter = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        exporter?.outputURL = outputURL
        exporter?.outputFileType=AVFileType.mov
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let _ = exporter?.error {
                    print("Cropping Failed")
                    completion("Error")
                } else {
                    print("Cropping Succeeded")
                    completion("Success")
                }
            }
        })
    }
    
    var fullRange: CMTimeRange {
        return CMTimeRange(start: .zero, duration: duration)
    }
    func trimmedComposition(_ range: CMTimeRange) -> AVAsset {
        guard CMTimeRangeEqual(fullRange, range) == false else {return self}

        let composition = AVMutableComposition()
        try? composition.insertTimeRange(range, of: self, at: .zero)

        if let videoTrack = tracks(withMediaType: .video).first {
            composition.tracks.forEach {$0.preferredTransform = videoTrack.preferredTransform}
        }
        return composition
    }
}
