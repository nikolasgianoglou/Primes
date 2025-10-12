//
//  FavotirePrimesView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct FavoritePrimes: View {
    @ObservedObject var state: FavoritePrimesState

  var body: some View {
      List {
          ForEach(state.favoritePrimes.indices, id: \.self) { index in
              Text("\(state.favoritePrimes[index])")
          }
          .onDelete { indexSet in
              for index in indexSet {
                  let prime = state.favoritePrimes[index]
                  state.favoritePrimes.remove(at: index)
                  state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
              }
          }
      }
      .navigationBarTitle(Text("Favorite Primes"))
      .listStyle(.plain)
  }
}
