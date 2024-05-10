//
//  Data+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import AVKit

extension Data{
    
    func toJSON() -> JSON{
        var json: JSON = ["":""]
        
        do{
            json = try JSON(data: self)
        }catch{
            print("Invalid Data")
        }
        return json
        
    }
    
    func toAVAsset() -> AVAsset {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mp4"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        let asset = AVAsset(url: fullURL!)
        return asset
    }
    
    func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        
        do {
            return try JSONDecoder().decode(object, from: self)
        } catch let error {
            print("Manually parsed  ", (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) ?? "nil")
            
            print("Error in Decoding OBject ", error)
            return nil
        }
        
    }
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
    
    func showSize() -> String{
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self.count))
        return string
    }
}
