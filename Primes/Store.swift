//
//  Store.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 12/10/25.
//

import Foundation

final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    @Published var value: Value
    
    init(
        value: Value,
        reducer: @escaping (inout Value, Action) -> Void
    ) {
        self.value = value
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
      reducer(&value, action)
    }
}

enum CounterAction {
  case decrTapped
  case incrTapped
}

func counterReducer(
  state: inout AppState, action: CounterAction
) {
  switch action {
  case .decrTapped:
      state.count -= 1
  case .incrTapped:
      state.count += 1
  }
}
