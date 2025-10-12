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
  var copy = state
  switch action {
  case .decrTapped:
    copy.count -= 1
  case .incrTapped:
    copy.count += 1
  }
  return copy
}
