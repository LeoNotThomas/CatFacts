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
    
    static public func initWith(fact: String, length: Int16, insertInto: Bool = false) -> CatFactEntity {
        let entity = NSEntityDescription.entity(forEntityName: "CatFactEntity", in: CatFactDataManager.shared.container.viewContext)
        let factEntity = CatFactEntity(entity: entity!, insertInto: insertInto == true ? CatFactDataManager.shared.container.viewContext : nil)
        factEntity.fact = fact
        factEntity.length = Int16(fact.count)
        factEntity.id = UUID()
        factEntity.saveDate = .now
        return factEntity
    }

}

extension CatFactEntity: Identifiable {

}
