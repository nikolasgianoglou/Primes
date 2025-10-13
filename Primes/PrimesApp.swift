//
//  PrimesApp.swift
//  Primes
//
//  Created by Nikolas Gianoglou Coelho on 09/10/25.
//

import SwiftUI

@main
struct PrimesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(value: AppState(), reducer: appReducer(state:action:)))
        }
    }
}
