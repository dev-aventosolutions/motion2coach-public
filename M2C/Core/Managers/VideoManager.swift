//
//  VideoManager.swift
//  M2C
//
//  Created by Abdul Samad Butt on 12/10/2022.
//

import Foundation
import UIKit
import CoreGraphics
import AVKit

class VideoManager{
    
    deinit {
        
    }
    func getFrames(url: URL, _ callback: @escaping (([UIImage]) -> ())) {
        
        let asset = AVURLAsset(url: url, options: nil)
        do{
            let reader = try AVAssetReader(asset: asset)
            let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
            var frames = [UIImage]()
            // read video frames as BGRA
            let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings:[String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
            reader.add(trackReaderOutput)
            reader.startReading()
            autoreleasepool {
                while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
                    if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                        let ciImage = CIImage(cvImageBuffer: imageBuffer)
                        frames.append(UIImage(ciImage: ciImage))
                    }
                }
            }
            callback(frames)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func getFrames(data: Data, points: HighlightPoints, _ callback: @escaping (([UIImage]) -> ())) {
        var counter: Int = -1
        
        //    framesCallback = callback
        let asset = data.toAVAsset()
        do{
            let reader = try AVAssetReader(asset: asset)
            let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
            var frames = [UIImage]()
            // read video frames as BGRA
            let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings:[String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
            reader.add(trackReaderOutput)
            reader.startReading()
            autoreleasepool {
                while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
//                    print(counter)
                    counter+=1
                    if let p1 = points.p1 {
                        if counter < p1 {
                            continue
                        }
                    }
                    if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                        let ciImage = CIImage(cvImageBuffer: imageBuffer)
                        let image = UIImage(ciImage: ciImage)
                        print(frames.count)
                        
                        // For Putting videos only
                        if Global.shared.selectedSwingType?.id == "3"{
                            
                            if let p1 = points.p1, let p4 = points.p4{
                                if (counter >= p1) && (counter <= p4){
                                    frames.append(image)
                                } else if counter > p4 {
                                    reader.cancelReading()
                                    break
                                }
                            }
                            
//                            if let p1 = points.p1, let p10 = points.p10{
//                                if (counter >= p1) && (counter <= p10){
//                                    frames.append(image)
//                                } else if counter > p10 {
//                                    reader.cancelReading()
//                                    break
//                                }
//                            }
                            
                        }else{
                            // For Full swing videos only
                            if let p1 = points.p1, let p10 = points.p10{
                                if (counter >= p1) && (counter <= p10){
                                    frames.append(image)
                                } else if counter > p10 {
                                    reader.cancelReading()
                                    break
                                }
                            }
                        }
                        
                    }
                }
            }
            callback(frames)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
