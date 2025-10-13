//
//  FavotirePrimesView.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 10/10/25.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
      List {
          ForEach(store.value.favoritePrimes.indices, id: \.self) { index in
              Text("\(store.value.favoritePrimes[index])")
          }
          .onDelete { indexSet in
              store.send(.favotirePrimes(.deleteFavoritePrimes(indexSet)))
          }
      }
      .navigationBarTitle(Text("Favorite Primes"))
      .listStyle(.plain)
  }
}
