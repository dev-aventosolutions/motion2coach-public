//
//  captureModel.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 17/05/2022.
//

import Foundation

struct CaptureModel {
    var videoName = ""
    var videoUrl = ""
    var id = ""
    var swingTypeId = 0
    var userId = ""
    var description = ""
    //kept datedAdded as String to display on UI
    var createdAt = Date()
    var datedAdded = ""
    var updatedAt = ""
    var orientation = ""
    var orientationId = ""
    var playerTypeId = ""
    var fps = ""
    var rating = ""
    var time = ""
    var thumbnail = Data()
    var fullDate = Date()
    var isExpanded = false
    var publicUrl = ""
    var status = ""
    var overlayUrl = ""
    var swingTypeName = ""
    var clubTypeName = ""
    var videoBinary = Data()
    
    init(data: CaptureEntity){
        self.overlayUrl = data.overlayUrl ?? ""
        self.videoName = data.videoName ?? ""
        self.videoUrl = data.videoUrl ?? ""
        self.status = data.status ?? ""
        let date = data.datedAdded ?? Date()
        self.datedAdded = date.toStringFromDate()
        self.time = date.stringFromDateWithOnlyTime()
        self.thumbnail = data.thumbnail ?? Data()
        self.publicUrl = data.publicUrl ?? ""
        self.videoBinary = data.videoBinary ?? Data()
        self.fullDate = data.datedAdded ?? Date()
    }
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.videoName = json["title"].stringValue
        self.description = json["description"].stringValue
        self.rating = json["rating"].stringValue
        self.fps = json["frameRate"].stringValue
        self.videoUrl = json["url"].stringValue
        self.updatedAt = json["updatedAt"].stringValue
        self.userId = json["userId"].stringValue
        self.playerTypeId = json["playerTypeId"].stringValue
        self.orientationId = json["orientationId"].stringValue
        self.overlayUrl = json["overlayUrl"].stringValue
        self.swingTypeId = json["swingTypeId"].intValue
        self.swingTypeName = json["swingTypename"].string ?? "Full Swing"
        self.clubTypeName = json["clubTypename"].string ?? "Iron"
        
        let date = json["createdAt"].stringValue.fullDateFromString()
        print("created at: ",date)
        self.datedAdded = date.toStringFromDate()
        print("Date added: ",datedAdded)
        self.createdAt = date
    }
    
    init(){
        
    }
}

