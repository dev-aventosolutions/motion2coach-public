//
//  CaptureEntity+CoreDataProperties.swift
//  
//
//  Created by Muhammad Bilal Hussain on 16/05/2022.
//
//

import Foundation
import CoreData


extension CaptureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaptureEntity> {
        return NSFetchRequest<CaptureEntity>(entityName: "CaptureEntity")
    }

    @NSManaged public var datedAdded: Date?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var videoName: String?
    @NSManaged public var videoUrl: String?
    @NSManaged public var publicUrl: String?
    @NSManaged public var videoBinary: Data?

}
