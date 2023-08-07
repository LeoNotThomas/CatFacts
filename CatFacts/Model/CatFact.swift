//
//  File.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import Foundation

// MARK: - CatFact
struct CatFact: Codable, Equatable {
    let fact: String
    let length: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fact == rhs.fact && lhs.length == rhs.length
    }
}
