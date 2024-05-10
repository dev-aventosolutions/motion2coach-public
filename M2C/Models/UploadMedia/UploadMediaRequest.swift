//
//  UploadMediaRequest.swift
//  M2C
//
//  Created by Abdul Samad Butt on 28/07/2022.
//

import Foundation

class UploadMediaRequest{
    
    static let shared = UploadMediaRequest()
    
    var fileMimeType: String = ""
    var fileName: String = ""
    var uploadingFor: Int = 0
    
    func returnUploadMediaParams() -> [String:Any]{
        
        let params:[String:Any] = [
            "fileMimeType" : fileMimeType,
            "fileName" : fileName,
            "uploadingFor": uploadingFor
        ]
        return params
    }
}
