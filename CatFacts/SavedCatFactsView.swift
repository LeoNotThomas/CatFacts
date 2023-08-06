//
//  SavedCatFactsView.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 04.08.23.
//

import SwiftUI

struct SavedCatFactsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.saveDate)]) var catFacts: FetchedResults<CatFactEntity>
    var body: some View {
        VStack {
            List {
                ForEach(catFacts.indices, id: \.self) { i in
                    HStack {
                        Text("\(i)")
                        Text(catFacts[i].fact ?? "Error")
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Saved CoreData")
    }
}

struct SavedCatFactsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCatFactsView()
    }
}
