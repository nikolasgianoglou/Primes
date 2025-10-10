//
//  FavotirePrimesView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct FavoritePrimes: View {
    @ObservedObject var state: AppState

  var body: some View {
      List {
          ForEach(state.favoritePrimes.indices, id: \.self) { index in
              Text("\(state.favoritePrimes[index])")
          }
          .onDelete { indexSet in
              for index in indexSet {
                  state.favoritePrimes.remove(at: index)
              }
          }
      }
      .navigationBarTitle(Text("Favorite Primes"))
  }
}
