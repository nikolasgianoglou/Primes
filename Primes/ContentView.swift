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
                NavigationLink(destination: EmptyView()) {
                    Text("Favorite primes")
                }
            }
            .navigationTitle("State management")
        }
    }
}

class AppState: ObservableObject {
    @Published var count = 0
    @Published var favoritePrimes: [Int] = []
}

struct CounterView: View {
    @ObservedObject var state: AppState
    @State var isPrimeModalShown = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    state.count -= 1
                }, label: {
                    Text("-")
                })
                
                Text("\(state.count)")
                
                Button(action: {
                    state.count += 1
                }, label: {
                    Text("+")
                })
            }
            
            Button(action: {
                isPrimeModalShown = true
            }, label: {
                Text("Is this prime?")
            })
            
            Button(action: {
                
            }, label: {
                Text("What is the \(ordinal(state.count)) prime?")
            })
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .sheet(isPresented: $isPrimeModalShown) {
            IsPrimeModalView(state: state)
        }
    }
}

#Preview {
    ContentView(state: AppState())
}
