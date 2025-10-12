//
//  CounterView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 12/10/25.
//

import SwiftUI

struct CounterView: View {
    @ObservedObject var state: AppState
    @State var isPrimeModalShown = false
    @State var alertNthPrime: Bool = false
    @State var nthPrime: Int? = 0
    @State var isNthPrimeButtonDisabled = false
    let service = Service()
    
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
            
            Button(action: nthPrimeButtonAction) {
                Text("What is the \(ordinal(state.count)) prime?")
            }
            .disabled(isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        .sheet(isPresented: $isPrimeModalShown) {
            IsPrimeModalView(state: state)
        }
        .alert(isPresented: $alertNthPrime) {
            Alert(title: Text("The \(ordinal(state.count)) prime is \(nthPrime ?? 0)"))
        }
    }
    
    func nthPrimeButtonAction() {
        guard state.count > 0 else { return }
        isNthPrimeButtonDisabled = true
        service.nthPrime(state.count) { prime in
            isNthPrimeButtonDisabled = false
            nthPrime = prime
            alertNthPrime = true
        }
    }
}
