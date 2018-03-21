//
//  FilmMO+CoreDataProperties.swift
//  
//
//  Created by Shekhtman Vladyslav on 3/17/18.
//
//

import Foundation
import CoreData


extension FilmMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmMO> {
        return NSFetchRequest<FilmMO>(entityName: "FilmEntity")
    }

    @NSManaged public var overview: String?
    @NSManaged public var posterName: String?
    @NSManaged public var rating: Float
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var year: String?

}
