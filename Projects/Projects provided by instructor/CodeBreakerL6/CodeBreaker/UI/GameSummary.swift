//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 14/01/26.
//

import SwiftUI

struct GameSummary: View {
    let size: Size
    
    enum Size {
        case compact
        case regular
        case large
        
        var larger: Self {
            switch self {
            case .compact: .regular
            default: .large
            }
        }
        
        var smaller: Self {
            switch self {
            case .large: .regular
            default: .compact
            }
        }
    }
    
    let game: CodeBreaker
    var body: some View {
        let layout = size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))
        layout {
            Text(game.name).font(size == .compact ? .body : .title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: size == .compact ? 35 :50)
            if size == .large {
                Text("^[ \(game.attempts.count ) attempt](inflect:true)")
            }
        }
    }
}

#Preview(traits: .swiftData ) {
    List{
        GameSummary(size: .large, game: CodeBreaker(name: "Preview Game", pegChoices: [.red, .cyan, .yellow, .purple]))
    }
    List{
        GameSummary(size: .compact, game: CodeBreaker(name: "Preview Game", pegChoices: [.red, .cyan, .yellow, .purple]))
    }
    .listStyle(.plain)
}
