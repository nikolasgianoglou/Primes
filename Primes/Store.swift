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
    
    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue else { return }
            self = .counter(newValue)
        }
    }
    var primeModal: PrimeModalAction? {
        get {
            guard case let .primeModal(value) = self else { return nil}
            return value
        }
        set {
            guard case .primeModal = self, let newValue else { return }
            self = .primeModal(newValue)
        }
    }
    var favoritePrimes: FavoritePrimesAction? {
        get {
            guard case let .favoritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .favoritePrimes = self, let newValue else { return }
            self = .favoritePrimes(newValue)
        }
    }
} /*/        \AppAction.counter -> WritableKeyPath<AppAction, CounterAction?>     */

enum FavoritePrimesAction {
  case removeFavoritePrimes(IndexSet)
}

let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(counterReducer, value: \.count, action: \.counter),           //pullback(counterReducer, get: { $0.count }, set: { $0.count = $1 }),
    pullback(primeModalReducer, value: \.self, action: \.primeModal),
    pullback(favoritePrimesReducer, value: \.favoritePrimesState, action: \.favoritePrimes)
)
//New
func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else  { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}


func pullback<Value, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout Value, LocalAction) -> Void,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout Value, GlobalAction) -> Void {
    return { value, globalAction in
        guard let localAction = globalAction[keyPath: action] else  { return }
        reducer (&value, localAction)
    }
}



//Old
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
    state: inout Int, action: CounterAction
) -> Void {
    switch action {
    case .decrTapped:
        state -= 1
        
    case .incrTapped:
        state += 1
    }
}

func primeModalReducer(
    state: inout AppState, action: PrimeModalAction
) -> Void {
  switch action {
  case .addFavoritePrime:
    state.favoritePrimes.append(state.count)
    state.activityFeed.append(
      .init(
        timestamp: Date(),
        type: .addedFavoritePrime(state.count)
      )
    )

  case .removeFavoritePrime:
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

struct FavoritePrimesState {
  var favoritePrimes: [Int]
  var activityFeed: [AppState.Activity]
}

func favoritePrimesReducer(
    state: inout FavoritePrimesState, action: FavoritePrimesAction
) -> Void {
  switch action {
  case let .removeFavoritePrimes(indexSet):
    for index in indexSet {
      state.activityFeed.append(
        .init(
          timestamp: Date(),
          type: .removedFavoritePrime(state.favoritePrimes[index])
        )
      )
      state.favoritePrimes.remove(at: index)
    }
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
