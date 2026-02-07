//
//  CodeWordBreakerApp.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 03/01/26.
//

import SwiftUI
import SwiftData

@main
struct CodeWordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            AllWordGamesView()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
