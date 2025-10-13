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

enum PrimeModalAction {
    case addFavoritePrime
    case removeFavoritePrime
}

enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favoritePrimes(FavoritePrimesAction)
}

enum FavoritePrimesAction {
  case removeFavoritePrimes(IndexSet)
}

//func appReducer(state: inout AppState, action: AppAction) {
//    switch action {
//    case .counter(.decrTapped):
//        state.count -= 1
//        
//    case .counter(.incrTapped):
//        state.count += 1
//        
//    case .primeModal(.addFavoritePrime):
//        state.favoritePrimes.append(state.count)
//        state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
//        
//    case .primeModal(.removeFavoritePrime):
//        state.favoritePrimes.removeAll(where: { $0 == state.count })
//        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
//        
//    case let .favoritePrimes(.removeFavoritePrimes(indexSet)):
//        for index in indexSet {
//            let prime = state.favoritePrimes[index]
//            state.favoritePrimes.remove(at: index)
//            state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
//        }
//    }
//}

let appReducer = combine(
  combine(counterReducer, primeModalReducer),
  favoritePrimesReducer
)

func combine<Value, Action>(
  _ first: @escaping (inout Value, Action) -> Void,
  _ second: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {

  return { value, action in
    first(&value, action)
    second(&value, action)
  }
}

func counterReducer(
    value: inout AppState, action: AppAction
) -> Void {
    switch action {
    case .counter(.decrTapped):
        value.count -= 1
        
    case .counter(.incrTapped):
        value.count += 1
        
    default:
        break
    }
}

func primeModalReducer(
  state: inout AppState, action: AppAction
) -> Void {
  switch action {
  case .primeModal(.addFavoritePrime):
    state.favoritePrimes.append(state.count)
    state.activityFeed.append(
      .init(
        timestamp: Date(),
        type: .addedFavoritePrime(state.count)
      )
    )

  case .primeModal(.removeFavoritePrime):
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    state.activityFeed.append(
      .init(
        timestamp: Date(),
        type: .removedFavoritePrime(state.count)
      )
    )

  default:
    break
  }
}

func favoritePrimesReducer(
  state: inout AppState, action: AppAction
) -> Void {
  switch action {
  case let .favoritePrimes(.removeFavoritePrimes(indexSet)):
    for index in indexSet {
      state.activityFeed.append(
        .init(
          timestamp: Date(),
          type: .removedFavoritePrime(state.favoritePrimes[index])
        )
      )
      state.favoritePrimes.remove(at: index)
    }

  default:
    break
  }
}
