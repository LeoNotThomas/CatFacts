//
//  ContentView.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model = CatFactsViewModel(apiCaller: APICaller())
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    Section("New Fact") {
                        NewFactView(model: model)
                    }
                    .alert("Error", isPresented: $model.showError) {
                        // no actions required
                    } message: {
                        Text(model.errorMessage)
                    }
                    Section("Fact List") {
                        ForEach(model.facts) { fact in
                            Text(fact.fact)
                        }
                    }
                }
                .padding()
                .navigationTitle("CatFact")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Saved Data") {
                            // only implemented to show a second way
                            SavedCatFactsView()
                                .environment(\.managedObjectContext, CatFactDataManager.shared.container.viewContext)
                        }
                    }
                }
                .onAppear {
                    model.getFacts()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct NewFactView: View {
    @StateObject var model: CatFactsViewModel
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "pawprint.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Spacer()
            Text(model.currentFact.fact)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Button("Load Next") {
                model.next()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
