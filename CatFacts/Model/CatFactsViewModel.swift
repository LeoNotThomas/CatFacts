//
//  CatFactViewModel.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 03.08.23.
//

import Foundation
import Combine

class CatFactsViewModel: ObservableObject {
    @Published private(set) var currentFact: CatFactViewModel?
    @Published private(set) var facts = [CatFactViewModel]()
    @Published var showError = false
    private(set) var errorMessage = ""
    private let manager = CatFactDataManager.shared
    private var cancelables = Set<AnyCancellable>()
    private var apiCaller: APIClientProtocol
    
    init(apiCaller: APIClientProtocol) {
        self.apiCaller = apiCaller
        setupBindings()
    }
    
    private func setupBindings() {
        manager.$data
            .receive(on: DispatchQueue.main)
            .sink { data in
                guard let data = data else {
                    return
                }
                self.currentFact = CatFactViewModel(fact: data)
                self.showError = false
            }
            .store(in: &cancelables)
        
        manager.$error
            .receive(on: DispatchQueue.main)
            .sink { error in
                guard let error = error else {
                    return
                }
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
            .store(in: &cancelables)
        manager.$factsEntities
            .receive(on: DispatchQueue.main)
            .sink { entities in
                var saveFacts = [CatFactViewModel]()
                for entity in entities {
                    saveFacts.append(CatFactViewModel(fact: entity))
                }
                self.facts = saveFacts
            }
            .store(in: &cancelables)
    }
    
    func next() {
        manager.getFact(caller: apiCaller)
    }
    
    func getFacts() {
        manager.getCatFacts()
    }
    
    func deleteFact(on: IndexSet) {
        for index in on {
            manager.delete(row: index)
        }
    }
    
    func removeAll() {
        manager.removeAll()
    }
}

struct CatFactViewModel: Equatable, Identifiable {
    var id: UUID
    var fact: String
    var length: Int
    var saveDate: Date
    
    init(fact: CatFactEntity) {
        self.id = fact.id!
        self.fact = fact.fact!
        self.length = Int(fact.length)
        self.saveDate = fact.saveDate!
    }
}
