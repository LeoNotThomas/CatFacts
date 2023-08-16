//
//  CatFactEntity+CoreDataClass.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 16.08.23.
//
//

import Foundation
import CoreData

@objc(CatFactEntity)
public class CatFactEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case fact
        case length
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init(context: CatFactDataManager.shared.container.viewContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        length = try values.decode(Int16.self, forKey: .length)
        fact = try values.decode(String.self, forKey: .fact)
        id = UUID()
        saveDate = .now
    }
    

}
