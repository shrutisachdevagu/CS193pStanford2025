//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 14/01/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data owned by me
    @State private var games: [CodeBreaker] = []
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offset, index in
                    games.move(fromOffsets: offset, toOffset: index)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs in
                PegChooser(choices: pegs)
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan, .yellow]))
        }
    }
}

#Preview {
    GameChooser()
}
