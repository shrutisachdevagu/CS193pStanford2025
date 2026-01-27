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
    
    var onExit: () -> Void?
    
    init(game: CodeBreaker?, onExit: @escaping () -> Void?) {
        if let game {
            self.game = game
            self.onExit = onExit
        } else {
            self.onExit = onExit
            self.game = CodeBreaker(codeLength: 5)
            self.game.masterCode.word = words.random(length: 5) ?? "AWAIT"
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .animation(nil, value: game.codeLength)
                .transaction { transaction in
                    if game.masterCode.isHidden {
                        transaction.animation = nil
                    }
                }

            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index])
                        .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .trailing)))
                }
            }
            VStack {
                if(!game.isOver) {
                    PegChooser(pegChoiceStatuses: game.pegChoiceStatuses) { peg in
                        game.setGuessPeg(peg, at: selection)
                        selection = (selection + 1) % game.codeLength
                    }
                    onDelete: { deleteSelectedCharacterFromGuess() }
                    onGuess: { withAnimation(.codeBreakerSlowEaseInOut) {
                        guessWord() }
                    }
                    .transition(.offset(x: 0,y: 200))
                }
            }
        }
        .onChange(of: game, { oldValue, newValue in
            print("On change of game in code breaker view is, the master code is : ")
            print(newValue.masterCode.word)
        })
        .onAppear {
            if game.masterCode.word.isEmpty {
                print("the game came with an empty master code")
                if words.count == 0 { // no words (yet)
                    game.masterCode.word = "AWAIT"
                } else {
                    game.masterCode.word = words.random(length: 5) ?? "ERROR"
                }
                print("the code breaker view gave the master code as \(game.masterCode.word)")
            } else {
                print("On appear the master code of the game in Code breaker view is: ")
                print(game.masterCode.word)
            }
        }
        .onDisappear {
            game.lastPlayedTime = Date.now
            onExit()
        }
//        .onChange(of: words.count, initial: true) {
//            if game.attempts.count == 0 { // don’t disrupt a game in progress
//                if words.count == 0 { // no words (yet)
//                    game.masterCode.word = "AWAIT"
//                } else {
//                    game.masterCode.word = words.random(length: 5) ?? "ERROR"
//                }
//                print("Master code is \(game.masterCode.word)")
//            }
//        }
        .padding()
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
        print("Guess is \(game.guess.word) and \(checker.isAWord(game.guess.word.lowercased()) ? "its" : "its not") a valid word")
        if !game.isGuessAlreadyAttempted() && !game.isGuessMissingPegs() && checker.isAWord(game.guess.word.lowercased()){
            game.attemptGuess()
            selection = 0
        }
        if !checker.isAWord(game.guess.word.lowercased()){
            game.guess.reset()
            selection = 0
        }
    }
}

#Preview {
    CodeWordBreakerView(game: CodeBreaker(codeLength: 5), onExit: {print("Exit")})
}

