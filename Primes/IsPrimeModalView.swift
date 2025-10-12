//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, CounterAction>
    
    var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime!!!! ✅")
                if store.value.favoritePrimes.contains(store.value.count) {
                    Button(action: {
                        store.value.favoritePrimes.removeAll(where: { $0 == store.value.count })
                        store.value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(store.value.count)))
                    }, label: {
                        Text("Remove from primes list")
                })
                } else {
                    Button(action: {
                        store.value.favoritePrimes.append(store.value.count)
                        store.value.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(store.value.count)))
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
