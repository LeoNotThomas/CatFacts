//
//  DataController.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 04.08.23.
//

import CoreData

class CatFactDataManager: ObservableObject {
    static let shared = CatFactDataManager()
    
    @Published private(set) var data: CatFactEntity?
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
    
    func getFact(caller: APIClientProtocol) {
        Task {
            do {
                let fact = try await caller.fetch(CatFactEntity.self, endpoint: CatEndpoint.catFact)
                self.data = fact
                self.factsEntities.insert(fact, at: 0)
                try? self.container.viewContext.save()
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
