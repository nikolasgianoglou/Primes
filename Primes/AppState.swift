//
//  AppState.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 11/10/25.
//

import Foundation

struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User?
    var activityFeed: [Activity] = []
    
    struct Activity {
      let timestamp: Date
      let type: ActivityType

      enum ActivityType {
        case addedFavoritePrime(Int)
        case removedFavoritePrime(Int)
      }
    }
    
    struct User {
      let id: Int
      let name: String
      let bio: String
    }
}

final class Store<Value>: ObservableObject {
    @Published var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

//extension AppState {
//  func addFavoritePrime() {
//    self.favoritePrimes.append(self.count)
//    self.activityFeed.append(
//      Activity(
//        timestamp: Date(),
//        type: .addedFavoritePrime(self.count)
//      )
//    )
//  }
//
//  func removeFavoritePrime(_ prime: Int) {
//    self.favoritePrimes.removeAll(where: { $0 == prime })
//    self.activityFeed.append(
//      Activity(
//        timestamp: Date(),
//        type: .removedFavoritePrime(prime)
//      )
//    )
//  }
//
//  func removeFavoritePrime() {
//    self.removeFavoritePrime(self.count)
//  }
//
//  func removeFavoritePrimes(at indexSet: IndexSet) {
//    for index in indexSet {
//      self.removeFavoritePrime(self.favoritePrimes[index])
//    }
//  }
//}
