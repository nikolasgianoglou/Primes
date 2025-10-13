//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime!!!! ✅")
                if store.value.favoritePrimes.contains(store.value.count) {
                    Button(action: {
                        store.send(.primeModal(.removeFavoritePrime))
                    }, label: {
                        Text("Remove from primes list")
                })
                } else {
                    Button(action: {
                        store.send(.primeModal(.addFavoritePrime))
                    }, label: {
                        Text("Save to favorite primes")
                })
                }
            } else {
                Text("\(store.value.count) is not prime!!!! :(")
            }
        }
    }
}
