//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 3/31/25.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
