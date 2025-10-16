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

let appReducer = combine(
    pullback(counterReducer, value: \.count),//pullback(counterReducer, get: { $0.count }, set: { $0.count = $1 }),
    primeModalReducer,
    favoritePrimesReducer
)

func pullback<LocalValue, GlobalValue, Action>(
  _ reducer: @escaping (inout LocalValue, Action) -> Void,
  value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
  return { globalValue, action in
    reducer(&globalValue[keyPath: value], action)
  }
}

func pullback<LocalValue, GlobalValue, Action>(
  _ reducer: @escaping (inout LocalValue, Action) -> Void,
  get: @escaping (GlobalValue) -> LocalValue,
  set: @escaping (inout GlobalValue, LocalValue) -> Void
) -> (inout GlobalValue, Action) -> Void {

  return  { globalValue, action in
    var localValue = get(globalValue)
    reducer(&localValue, action)
    set(&globalValue, localValue)
  }
}

func combine<Value, Action>(
  _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {

  return { value, action in
    for reducer in reducers {
      reducer(&value, action)
    }
  }
}

func counterReducer(
    state: inout Int, action: AppAction
) -> Void {
    switch action {
    case .counter(.decrTapped):
        state -= 1
        
    case .counter(.incrTapped):
        state += 1
        
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







/*
 It’s responsible for combining the current state of our entire application with any user action by performing the appropriate mutation to state. It’s handling three different screens and five different user actions. This function is already getting pretty long! As we get more and more screens, this function is going to get gigantic.
 */
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
