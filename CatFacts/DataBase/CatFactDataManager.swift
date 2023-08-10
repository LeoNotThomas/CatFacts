//
//  DataController.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 04.08.23.
//

import CoreData

class CatFactDataManager: ObservableObject {
    static let shared = CatFactDataManager()
    
    @Published private(set) var data: CatFact?
    @Published private(set) var error: Error?
    @Published private(set) var factsEntities = [CatFactEntity]()
    
    let container = NSPersistentContainer(name: "CatFacts")
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load \(error.localizedDescription)")
            }
        }
    }
    private func saveEntity(_ fact: CatFact) -> CatFactEntity {
        let entity = CatFactEntity(context: CatFactDataManager.shared.container.viewContext)
        entity.id = UUID()
        entity.fact = fact.fact
        entity.length = Int16(fact.length)
        entity.saveDate = .now
        try? self.container.viewContext.save()
        return entity
    }
    
    func getFact(caller: APIClientProtocol) {
        Task {
            do {
                let fact = try await caller.fetch(CatFact.self, endpoint: CatEndpoint.catFacts)
                self.data = fact
                self.factsEntities.insert(saveEntity(fact), at: 0)
            } catch {
                self.error = error
            }
        }
    }
    
    func getCatFacts() {
        let fetch = CatFactEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CatFactEntity.saveDate), ascending: false)
        fetch.sortDescriptors = [sortDescriptor]
        do {
            let managedContext = self.container.viewContext
            let results = try managedContext.fetch(fetch)
            factsEntities = results
        } catch let error as NSError {
            self.error = error
        }
    }
    
    func delete(row: Int) {
        let managedContext = self.container.viewContext
        let fact = factsEntities.remove(at: row)
        managedContext.delete(fact)
        try? managedContext.save()
    }
}
