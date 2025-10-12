//
//  Store.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 12/10/25.
//

import Foundation

final class Store<Value>: ObservableObject {
    @Published var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

enum CounterAction {
  case decrTapped
  case incrTapped
}

func counterReducer(
  state: AppState, action: CounterAction
) -> AppState {
  switch action {
  case .decrTapped:
    return AppState(
      count: state.count - 1,
      favoritePrimes: state.favoritePrimes,
      loggedInUser: state.loggedInUser,
      activityFeed: state.activityFeed
    )
  case .incrTapped:
    return AppState(
      count: state.count + 1,
      favoritePrimes: state.favoritePrimes,
      loggedInUser: state.loggedInUser,
      activityFeed: state.activityFeed
    )
  }
}
