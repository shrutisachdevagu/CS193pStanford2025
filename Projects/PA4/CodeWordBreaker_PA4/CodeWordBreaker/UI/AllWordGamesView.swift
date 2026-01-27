//
//  AllWordGames.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 26/01/26.
//

import SwiftUI

struct AllWordGamesView: View {
    
    // MARK: Data Shared with Me
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var allGames:[CodeBreaker] = []
    @State private var newGame:CodeBreaker = CodeBreaker(codeLength: 5)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allGames){ game in
                    NavigationLink(value: game) {
                        WordGameSummaryView(game: game)
                    }
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeWordBreakerView(game: game) {
                    print("Exited")
                    if let index = allGames.firstIndex(of: game) {
                        allGames[index] = game
                        allGames.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
                    } else {
                        allGames.insert(game, at: 0)
                    }
                    newGame = CodeBreaker(codeLength: 5)
                }
            }
            .navigationTitle("My games")
            .toolbar {
                NavigationLink(value: newGame) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}



#Preview {
    AllWordGamesView()
}
