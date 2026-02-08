//
//  GamesChooser.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 08/02/26.
//

import SwiftUI
import SwiftData

struct GamesChooser: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings
    
    // MARK: Data Owned by Me
    @State private var newGame:CodeBreaker = CodeBreaker(codeLength: 5)
    @State private var selection: CodeBreaker? = nil
    @State private var isSettingSheetPresented: Bool = false
    
    var body: some View {
        NavigationSplitView {
            GamesList(selection: $selection)
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
        }
        detail: {
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
            modelContext.insert(game)
//            allGames.insert(game, at: 0)
            game.masterCode.word = words.random(length: game.codeLength) ?? dummyWord(of: game.codeLength)
            newGame = CodeBreaker(codeLength: game.codeLength)
        }
        game.startTimer()
    }
    
    func afterSwitchingFrom(game: CodeBreaker) {
//        if let index = allGames.firstIndex(of: game) {
////            allGames[index] = game
////            allGames.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
//            modelContext.delete(allGames[index])
//            modelContext.insert(game)
//        }
        // FIX: Don't delete and re-insert! SwiftData already tracks changes.
        // Just update the lastPlayedTime to trigger re-sorting if needed
        game.lastPlayedTime = Date.now
        game.pauseTimer()
        newGame = CodeBreaker(codeLength: gameSettings.codeLength)
    }
}

#Preview(traits: .swiftData) {
    GamesChooser()
}
