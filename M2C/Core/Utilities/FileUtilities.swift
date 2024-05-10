//
//  FileUtilities.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation


class FileUtilities: NSObject {
    static let sharedUtilites = FileUtilities()
    
    func saveImageFromData(data:Data,fileName:String!)->Bool{
        do{
            let pth =  getImageURL(name:fileName)
            if FileManager.default.fileExists(atPath: pth!.path) {
                try FileManager.default.removeItem(at: pth!)
            }
            try data.write(to: getImageURL(name: fileName), options: NSData.WritingOptions.atomicWrite)
            return true
        }catch{
            print("error copying image")
            return false
        }
    }
    func getImageURL(name:String!)->URL!{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name+".jpg")
    }
    func removePics(){
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do{
            let pths = try FileManager.default.contentsOfDirectory(atPath: docDir.path)
            for p in pths{
                if p.contains(".jpg"){
                    try FileManager.default.removeItem(atPath: docDir.appendingPathComponent(p).path)
                }
            }
        }catch{
            print(error)
        }
        
    }
}
