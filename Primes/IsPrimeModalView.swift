//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if isPrime(state.count) {
                Text("\(state.count) is prime!!!! ✅")
                if state.favoritePrimes.contains(state.count) {
                    Button(action: {
                        state.favoritePrimes.removeAll(where: { $0 == state.count })
                        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
                    }, label: {
                        Text("Remove from primes list")
                })
                } else {
                    Button(action: {
                        state.favoritePrimes.append(state.count)
                        state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
                    }, label: {
                        Text("Save to favorite primes")
                })
                }
            } else {
                Text("\(state.count) is not prime!!!! :(")
            }
        }
    }
}
