//
//  ContentView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 09/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: CounterView(store: store)) {
                    Text("Counter Demo")
                }
                NavigationLink(destination: FavoritePrimesView(store: store)) {
                    Text("Favorite primes")
                }
            }
            .navigationTitle("State management")
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView(store: Store(value: AppState(), reducer: appReducer(state:action:)))
}
