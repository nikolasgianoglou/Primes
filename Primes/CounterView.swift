//
//  CounterView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 12/10/25.
//

import SwiftUI

struct CounterView: View {
    @ObservedObject var store: Store<AppState, CounterAction>
    @State var isPrimeModalShown = false
    @State var alertNthPrime: Bool = false
    @State var nthPrime: Int? = 0
    @State var isNthPrimeButtonDisabled = false
    let service = Service()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.decrTapped)
                }, label: {
                    Text("-")
                })
                
                Text("\(store.value.count)")
                
                Button(action: {
                    store.send(.incrTapped)
                }, label: {
                    Text("+")
                })
            }
            
            Button(action: {
                isPrimeModalShown = true
            }, label: {
                Text("Is this prime?")
            })
            
            Button(action: nthPrimeButtonAction) {
                Text("What is the \(ordinal(store.value.count)) prime?")
            }
            .disabled(isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .sheet(isPresented: $isPrimeModalShown) {
            IsPrimeModalView(store: store)
        }
        .alert(isPresented: $alertNthPrime) {
            Alert(title: Text("The \(ordinal(store.value.count)) prime is \(nthPrime ?? 0)"))
        }
    }
    
    func nthPrimeButtonAction() {
        guard store.value.count > 0 else { return }
        isNthPrimeButtonDisabled = true
        service.nthPrime(store.value.count) { prime in
            isNthPrimeButtonDisabled = false
            nthPrime = prime
            alertNthPrime = true
        }
    }
}
