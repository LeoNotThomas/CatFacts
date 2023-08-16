//
//  CatFactEntity+CoreDataProperties.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 16.08.23.
//
//

import Foundation
import CoreData


extension CatFactEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatFactEntity> {
        return NSFetchRequest<CatFactEntity>(entityName: "CatFactEntity")
    }

    @NSManaged public var fact: String?
    @NSManaged public var id: UUID?
    @NSManaged public var length: Int16
    @NSManaged public var saveDate: Date?
}

extension CatFactEntity: Identifiable {

}
