//
//  CodeWordBreakerView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct  CodeWordBreakerView: View {
    
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Shared with me
    @Bindable var game: CodeBreaker
    
    // MARK: Data Owned by me
    @State private var selection: Int = 0
    @State private var checker = UITextChecker()
    
    var onEntry: () -> Void?
    var onExit: () -> Void?
    
    init(game: CodeBreaker, onEntry: @escaping () -> Void?, onExit: @escaping () -> Void?) {
        self.game = game
        self.onEntry = onEntry
        self.onExit = onExit
        onEntry()
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            masterCode
            ScrollView {
                guessCode
                attemptCodes
            }
            pegChooserKeyboard
        }
        .padding()
        .onAppear {
            game.startTimer()
        }
        .onDisappear {
            game.pauseTimer()
        }
        .onChange(of: game) { oldGame, newGame in
//            oldGame.pauseTimer()
//            newGame.startTimer()
            selection = 0
        }
        .toolbar {
            ToolbarItem {
                ElapsedTimerView(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime, isOver: game.isOver)
                    .monospaced()
                    .lineLimit(1)
            }
        }
    }
    
    var masterCode: some View {
        CodeView(code: game.masterCode)
            .animation(nil, value: game.codeLength)
            .transaction { transaction in
                if game.masterCode.isHidden {
                    transaction.animation = nil
                }
            }
    }
    
    @ViewBuilder
    var guessCode: some View {
        if !game.isOver {
            CodeView(code: game.guess, selection: $selection)
        }
    }
    
    var attemptCodes: some View {
        ForEach(game.attempts.indices.reversed(), id: \.self) { index in
            CodeView(code: game.attempts[index])
                .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .trailing)))
        }
    }
    
    var pegChooserKeyboard: some View {
        VStack {
            if(!game.isOver) {
                PegChooser(pegChoiceStatuses: game.pegChoiceStatuses) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.codeLength
                }
                onDelete: { deleteSelectedCharacterFromGuess() }
                onGuess: { withAnimation(.codeBreakerSlowEaseInOut) { guessWord() } }
                    .transition(.offset(x: 0,y: 200))
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
    
    fileprivate func deleteSelectedCharacterFromGuess() {
        if game.guess.pegs[selection] != "" {
            game.resetGuessPeg(at: selection)
        }
        else if selection > 0 {
            selection = (selection - 1) % game.codeLength
            game.resetGuessPeg(at: selection)
        } else {
            selection = game.codeLength - 1
            game.resetGuessPeg(at: selection)
        }
    }
    
    fileprivate func guessWord() {
//        print("Guess is \(game.guess.word) and \(checker.isAWord(game.guess.word.lowercased()) ? "its" : "its not") a valid word")
        if !game.isGuessAlreadyAttempted() && !game.isGuessMissingPegs() && checker.isAWord(game.guess.word.lowercased()){
            game.attemptGuess()
            selection = 0
        }
        if !checker.isAWord(game.guess.word.lowercased()){
            game.guess.reset()
            selection = 0
        }
        game.lastPlayedTime = Date.now
        onExit()
    }
}

#Preview(traits: .swiftData) {
    CodeWordBreakerView(game: CodeBreaker(codeLength: 5), onEntry: {print("Entry")}, onExit: {print("Exit")})
}

