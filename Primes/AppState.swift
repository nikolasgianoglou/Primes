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

extension AppState {
    mutating func addFavoritePrime() {
        self.favoritePrimes.append(count)
        self.activityFeed.append(
            Activity(
                timestamp: Date(),
                type: .addedFavoritePrime(count)
            )
        )
    }
    
    mutating func removeFavoritePrime(_ prime: Int) {
        favoritePrimes.removeAll(where: { $0 == prime })
        activityFeed.append(
            Activity(
                timestamp: Date(),
                type: .removedFavoritePrime(prime)
            )
        )
    }
    
    mutating func removeFavoritePrime() {
        removeFavoritePrime(count)
    }
    
    mutating func removeFavoritePrimes(at indexSet: IndexSet) {
        for index in indexSet {
            removeFavoritePrime(favoritePrimes[index])
        }
    }
}
