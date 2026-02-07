//
//  AllWordGames.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 26/01/26.
//

import SwiftUI
import SwiftData

struct AllWordGamesView: View {
    
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings
    @Query private var allGames:[CodeBreaker]

    
    // MARK: Data Owned by Me
    @State private var newGame:CodeBreaker = CodeBreaker(codeLength: 5)
    @State private var selection: CodeBreaker? = nil
    @State private var isSettingSheetPresented: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(allGames){ game in
                    NavigationLink(value: game) {
                        WordGameSummaryView(game: game) {
                            selection = game
                        }
                        .contextMenu {
                            Button("Delete", systemImage: "trash.fill") {
                                modelContext.delete(game)
//                                allGames.remove(at: allGames.firstIndex(of: game)!)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(allGames[index])
                    }
//                    allGames.remove(atOffsets: indexSet)
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
//                EditButton()
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
        .onChange(of: gameSettings.codeLength) {
            newGame.restart(codeLength: gameSettings.codeLength)
        }
        .onAppear {
            //preLoadSampleGames()
            GameSettings.loadGSCodeLengthFromDefaults()
            preLoadSampleGames()
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
    
    func dummyWord(of length: Int) -> String {
        switch length {
        case 3: return "ATE"
        case 4: return "FOUR"
        case 5: return "AWAIT"
        case 6: return "SANITY"
        default: return ""
        }
    }
    
    func preLoadSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let resultsCount = try? modelContext.fetchCount(fetchDescriptor), resultsCount == 0 {
            let game1 = CodeBreaker(codeLength: 4)
            game1.restart(codeLength: game1.codeLength)
            game1.masterCode.word = words.random(length: game1.codeLength) ?? dummyWord(of: game1.codeLength)
            game1.guess.word = "STOP"
            game1.attemptGuess()
            game1.guess.word = "FATE"
            game1.attemptGuess()
            //        allGames.insert(game1, at: 0)
            modelContext.insert(game1)
            let game2 = CodeBreaker(codeLength: 6)
            game2.restart(codeLength: game2.codeLength)
            game2.masterCode.word = words.random(length: game2.codeLength) ?? dummyWord(of: game2.codeLength)
            game2.guess.word = "CLAIMS"
            game2.attemptGuess()
            //        allGames.insert(game2, at: 0)
            modelContext.insert(game2)
        }
    }
}



#Preview(traits: .swiftData) {
    AllWordGamesView()
}
