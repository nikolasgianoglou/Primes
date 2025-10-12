//
//  ContentView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 09/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var state: AppState

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: CounterView(state: state)) {
                    Text("Counter Demo")
                }
                NavigationLink(destination: FavoritePrimes(state: FavoritePrimesState(state: state))) {
                    Text("Favorite primes")
                }
            }
            .navigationTitle("State management")
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView(state: AppState())
}
