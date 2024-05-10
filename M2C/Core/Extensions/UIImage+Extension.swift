//
//  UIImage.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

extension UIImage{
    
    func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let image = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }
    
    func normalized() -> [Float32]? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let w = cgImage.width
        let h = cgImage.height
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * w
        let bitsPerComponent = 8
        var rawBytes: [UInt8] = [UInt8](repeating: 0, count: w * h * 4)
        rawBytes.withUnsafeMutableBytes { ptr in
            if let cgImage = self.cgImage,
                let context = CGContext(data: ptr.baseAddress,
                                        width: w,
                                        height: h,
                                        bitsPerComponent: bitsPerComponent,
                                        bytesPerRow: bytesPerRow,
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
                let rect = CGRect(x: 0, y: 0, width: w, height: h)
                context.draw(cgImage, in: rect)
            }
        }
        var normalizedBuffer: [Float32] = [Float32](repeating: 0, count: w * h * 3)
        for i in 0 ..< w * h {
            normalizedBuffer[i] = Float32(rawBytes[i * 4 + 0]) / 255.0
            normalizedBuffer[w * h + i] = Float32(rawBytes[i * 4 + 1]) / 255.0
            normalizedBuffer[w * h * 2 + i] = Float32(rawBytes[i * 4 + 2]) / 255.0
        }
        return normalizedBuffer
    }
    
    func ToBase64() -> String {
        let imageData = self.jpegData(compressionQuality: 0.2)
        return imageData!.base64EncodedString(options: .lineLength64Characters)
    }
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    var pngRepresentationData: Data? {
        return self.pngData()
    }
    var jpegRepresentationData: Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
    
    func compressImage(compressionRate: CGFloat) -> UIImage {
        return UIImage(data:self.jpegData(compressionQuality: compressionRate)!,scale:1.0)!
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Move origin to middle
        context?.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context?.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func toPixelBuffer() -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: self.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
}

extension UIImage {
    
    func toJpegData (compressionQuality: CGFloat, hasAlpha: Bool = true, orientation: Int = 6) -> Data? {
        guard cgImage != nil else { return nil }
        let options: NSDictionary = [kCGImagePropertyOrientation: orientation, kCGImagePropertyHasAlpha: hasAlpha, kCGImageDestinationLossyCompressionQuality: compressionQuality ]
        return toData(options: options, type: .jpeg)
    }
    
    func toData (options: NSDictionary, type: ImageType) -> Data? {
        guard cgImage != nil else { return nil }
        return toData(options: options, type: type.value)
    }
    
    // about properties: https://developer.apple.com/documentation/imageio/1464962-cgimagedestinationaddimage
    func toData (options: NSDictionary, type: CFString) -> Data? {
        guard let cgImage = cgImage else { return nil }
        return autoreleasepool { () -> Data? in
            let data = NSMutableData()
            guard let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, type, 1, nil) else { return nil }
            CGImageDestinationAddImage(imageDestination, cgImage, options)
            CGImageDestinationFinalize(imageDestination)
            return data as Data
        }
    }
    
    // https://developer.apple.com/documentation/mobilecoreservices/uttype/uti_image_content_types
    enum ImageType {
        case image // abstract image data
        case jpeg                       // JPEG image
        case jpeg2000                   // JPEG-2000 image
        case tiff                       // TIFF image
        case pict                       // Quickdraw PICT format
        case gif                        // GIF image
        case png                        // PNG image
        case quickTimeImage             // QuickTime image format (OSType 'qtif')
        case appleICNS                  // Apple icon data
        case bmp                        // Windows bitmap
        case ico                        // Windows icon data
        case rawImage                   // base type for raw image data (.raw)
        case scalableVectorGraphics     // SVG image
        case livePhoto                  // Live Photo
        
        var value: CFString {
            switch self {
            case .image: return kUTTypeImage
            case .jpeg: return kUTTypeJPEG
            case .jpeg2000: return kUTTypeJPEG2000
            case .tiff: return kUTTypeTIFF
            case .pict: return kUTTypePICT
            case .gif: return kUTTypeGIF
            case .png: return kUTTypePNG
            case .quickTimeImage: return kUTTypeQuickTimeImage
            case .appleICNS: return kUTTypeAppleICNS
            case .bmp: return kUTTypeBMP
            case .ico: return kUTTypeICO
            case .rawImage: return kUTTypeRawImage
            case .scalableVectorGraphics: return kUTTypeScalableVectorGraphics
            case .livePhoto: return kUTTypeLivePhoto
            }
        }
    }
}
