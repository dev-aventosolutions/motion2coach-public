//
//  ImageCaptureModel.swift
//  M2C
//
//  Created by Abdul Samad Butt on 04/08/2022.
//

import Foundation

struct ImageCaptureModel {
    
    var imageName = ""
    var imageLocalUrl = ""
    //kept datedAdded as String to display on UI
    var dateAdded = ""
    var publicUrl = ""
    var imageBinary = Data()
    
    init(data: ImageCaptureEntity){
        self.imageName = data.imageName ?? ""
        self.imageLocalUrl = data.imageLocalUrl ?? ""
        let date = data.dateAdded ?? Date()
        self.dateAdded = date.toStringFromDate()
        self.publicUrl = data.publicUrl ?? ""
        self.imageBinary = data.imageBinary ?? Data()
    }
    
    init(){
        
    }
}
