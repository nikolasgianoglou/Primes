//
//  FavoritePrimesState.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 11/10/25.
//

import Foundation

class FavoritePrimesState: ObservableObject {

  private var state: AppState
    
  init(state: AppState) {
    self.state = state
  }

  var favoritePrimes: [Int] {
    get { state.favoritePrimes }
    set { state.favoritePrimes = newValue }
  }

  var activityFeed: [AppState.Activity] {
    get { state.activityFeed }
    set { state.activityFeed = newValue }
  }
}
