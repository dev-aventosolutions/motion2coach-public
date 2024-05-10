//
//  DocumentDirectory.swift
//  M2C
//
//  Created by Abdul Samad Butt on 17/10/2022.
//

import Foundation
import UIKit
import PDFKit

class DocumentDirectory: NSObject, UINavigationControllerDelegate {
    
    var pickPDFCallBack : ((PDFDocument) -> ())?
    
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func saveFile(image:UIImage, name:String) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    class func saveData(data:Data, name:String) {
        let path = getDocumentsDirectory().appendingPathComponent(name)
        do {
            try data.write(to: path)
        }catch{
            print("Unable to save video in File Manager")
        }
    }
    
    // Will return the url and Data
    class func getData(using path: String) -> (Data?, URL?) {

        if FileManager.default.fileExists(atPath: DocumentDirectory.urlInDocumentsDirectory(with: path.replaceString(fromString: ".mp4", toString: "")).absoluteString){
            do{
                let url = URL(fileURLWithPath: DocumentDirectory.urlInDocumentsDirectory(with: path.replaceString(fromString: ".mp4", toString: "")).absoluteString)
                let data = try Data(contentsOf: url)
                return (data, url)
                
            }catch let error{
                print(error.localizedDescription)
                print("Unable to fetch data from Document Directory")
            }
            
        }else{
            return (nil, nil)
        }
        
        return (nil, nil)
    }
    
    func getDocumentsURL() -> URL {
        let urlStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let url = URL(string: urlStr!)
        return url!
    }
    
    class func getImage(using path: String) -> UIImage? {
        let lastPathComponent = path.pathToName()
        let path = DocumentDirectory.urlInDocumentsDirectory(with: lastPathComponent).path
        let image = UIImage(contentsOfFile: path)
        return image
    }
    
    class func getPDF(path: String) -> PDFDocument? {
        let lastPathComponent = path.pathToName()
        let path = getDocumentsDirectory().appendingPathComponent(lastPathComponent)
        if let pdf = PDFDocument(url: path){
            return pdf
        }
        return PDFDocument()
    }
    
    class func savePDF(pdf: PDFDocument, name: String) {
        let lastPathComponent = name.pathToName() + ".pdf"
        
        let fullPath = getDocumentsDirectory().appendingPathComponent(lastPathComponent)
        pdf.write(to: fullPath)
        
    }
    
}


extension String {
    func pathToName() -> String {
        return self.replacingOccurrences(of: "/", with: "_")
    }
}
