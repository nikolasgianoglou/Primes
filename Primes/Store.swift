//
//  Store.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 12/10/25.
//

import Foundation

final class Store<Value, Action>: ObservableObject {
    let reducer: (Value, Action) -> Value
    @Published var value: Value
    
    init(
        value: Value,
        reducer: @escaping (Value, Action) -> Value
    ) {
        self.value = value
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
      value = self.reducer(self.value, action)
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
