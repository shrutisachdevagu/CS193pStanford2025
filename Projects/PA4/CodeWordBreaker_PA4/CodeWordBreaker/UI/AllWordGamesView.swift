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
    @Environment(\.gameSettings) var gameSettings
    
    // MARK: Data Owned by Me
    @State private var allGames:[CodeBreaker] = []
    @State private var newGame:CodeBreaker = CodeBreaker(codeLength: 5)
    @State private var selection: CodeBreaker? = nil
    @State private var isSettingSheetPresented: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(allGames){ game in
                    NavigationLink(value: game) {
                        WordGameSummaryView(game: game) {
                            selection = game
                        }
                    }
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeWordBreakerView(game: game) {
                    beforeStarting(game: game)
                    selection = game
                } onExit: {
                    afterSwitchingFrom(game: game)
                }
            }
            .navigationTitle("My games")
            .toolbar {
                NavigationLink(value: newGame) {
                    Image(systemName: "plus")
                }
                Image(systemName: "gearshape.fill")
                    .onTapGesture {
                        isSettingSheetPresented = true
                    }
                    .sheet(isPresented: $isSettingSheetPresented) {
                        GameSettingsView()
                    }
            }
        } detail: {
            if let selection {
                CodeWordBreakerView(game: selection, onEntry: {
                    beforeStarting(game: selection)
                }, onExit: {
                    afterSwitchingFrom(game: selection)
                })
            } else {
                Text("Create a game")
            }
        }
    }
    
    func beforeStarting(game: CodeBreaker) {
        if game.masterCode.word.isEmpty {
            allGames.insert(game, at: 0)
        }
    }
    
    func afterSwitchingFrom(game: CodeBreaker) {
        if let index = allGames.firstIndex(of: game) {
            allGames[index] = game
            allGames.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        }
    }
}



#Preview {
    AllWordGamesView()
}
