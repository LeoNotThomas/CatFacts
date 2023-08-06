//
//  CatFactViewModel.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 03.08.23.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class CatFactsViewModel: ObservableObject {
    @Published private(set) var currentFact = CatFactViewModel(CatFact(fact: "No Fact Loaded", length: 0)) {
        didSet {
            facts.insert(currentFact, at: 0)
            manager.save(self.currentFact)
        }
    }
    @Published private(set) var facts = [CatFactViewModel]()
    @Published var showError = false
    private(set) var errorMessage = ""
    private let manager = CatFactDataManager.shared
    private var cancelables = Set<AnyCancellable>()
    
    init() {
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
    }
    
    func next() {
        manager.getFact()
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
    
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.saveDate == rhs.saveDate
//    }
}
