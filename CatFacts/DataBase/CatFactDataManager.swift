//
//  DataController.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 04.08.23.
//

import CoreData
import Foundation

class CatFactDataManager: ObservableObject {
    static let shared = CatFactDataManager()
    
    @Published private(set) var data: CatFact?
    @Published private(set) var error: Error?
    func getFact(caller: APIClientProtocol) {
        Task {
            do {
                let fact = try await caller.fetch(CatFact.self, endpoint: CatEndpoint.catFacts)
                self.data = fact
            } catch {
                self.error = error
            }
        }
    }
    
    func save(_ fact: CatFactViewModel) {
        let entity = CatFactEntity(context: self.container.viewContext)
        entity.id = fact.id
        entity.fact = fact.fact
        entity.length = Int16(fact.length)
        entity.saveDate = fact.saveDate
        
        try? self.container.viewContext.save()
    }
    
    let container = NSPersistentContainer(name: "CatFacts")
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load \(error.localizedDescription)")
            }
        }
    }
}
