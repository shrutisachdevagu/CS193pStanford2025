//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 14/01/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var body: some View {
        VStack(alignment: .leading ) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[ \(game.attempts.count ) attempt](inflect:true)")
        }    }
}

#Preview {
    List{
        GameSummary(game: CodeBreaker(name: "Preview Game", pegChoices: [.red, .cyan, .yellow, .purple]))
    }
    List{
        GameSummary(game: CodeBreaker(name: "Preview Game", pegChoices: [.red, .cyan, .yellow, .purple]))
    }
    .listStyle(.plain)
}
