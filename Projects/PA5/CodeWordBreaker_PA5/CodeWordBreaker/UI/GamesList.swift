//
//  AllWordGames.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 26/01/26.
//

import SwiftUI
import SwiftData

struct GamesList: View {
    
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings
    @Query private var allGames:[CodeBreaker]

    
    // MARK: Data Owned by Me
    @State private var newGame:CodeBreaker = CodeBreaker(codeLength: 5)
    @Binding var selection: CodeBreaker?
    
    // MARK: - Body
    
    var body: some View {
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
        .onChange(of: gameSettings.codeLength) {
            newGame.restart(codeLength: gameSettings.codeLength)
        }
        .onAppear {
            //preLoadSampleGames()
            GameSettings.loadGSCodeLengthFromDefaults()
            preLoadSampleGames()
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
    @Previewable @State var selectedGame :CodeBreaker? = CodeBreaker(codeLength: 5)
    GamesList(selection: $selectedGame)
}
