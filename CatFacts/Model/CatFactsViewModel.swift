//
//  CatFactViewModel.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 03.08.23.
//

import Foundation
import Combine

class CatFactsViewModel: ObservableObject {
    @Published private(set) var currentFact = CatFactViewModel(CatFact(fact: "No Fact Loaded", length: 0))
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
                self.currentFact = CatFactViewModel(data)
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
            .sink { entities in
                guard !entities.isEmpty else {
                    return
                }
                var saveFacts = [CatFactViewModel]()
                for entity in entities {
                    saveFacts.append(CatFactViewModel(fact: entity))
                }
                DispatchQueue.main.async {
                    self.facts = saveFacts
                }
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
}

struct CatFactViewModel: Equatable, Identifiable {
    var id: UUID
    var fact: String
    var length: Int
    var saveDate: Date
    
    init(_ fact: CatFact) {
        self.id = UUID()
        self.fact = fact.fact
        self.length = fact.length
        self.saveDate = .now
    }
    
    init(fact: CatFactEntity) {
        self.id = fact.id!
        self.fact = fact.fact!
        self.length = Int(fact.length)
        self.saveDate = fact.saveDate!
    }
}
