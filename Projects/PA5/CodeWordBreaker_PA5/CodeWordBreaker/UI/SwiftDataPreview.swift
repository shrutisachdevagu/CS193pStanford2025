//
//  SwiftDataPreview.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 07/02/26.
//


import SwiftUI
import SwiftData

struct SwiftDataPreview:PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: CodeBreaker.self, configurations: .init(isStoredInMemoryOnly: true))
        return container
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}

