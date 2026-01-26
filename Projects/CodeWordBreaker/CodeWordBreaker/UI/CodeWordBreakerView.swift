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
    
    // MARK: Data Owned by me
    @State private var game = CodeBreaker()
    @State private var selection: Int = 0
    @State private var checker = UITextChecker()
    
    // MARK: - Body
    var body: some View {
        VStack {
            view(for: game.masterCode)
                .animation(nil, value: game.codeLength)
                .transaction { transaction in
                    if game.masterCode.isHidden {
                        transaction.animation = nil
                    }
                }

            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                        .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .trailing)))
                }
            }
            codeLengthChooserAndRestarter
                .padding()
                .buttonStyle(.bordered)
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
        .onChange(of: words.count, initial: true) {
            if game.attempts.count == 0 { // don’t disrupt a game in progress
                if words.count == 0 { // no words (yet)
                    game.masterCode.word = "AWAIT"
                } else {
                    game.masterCode.word = words.random(length: 5) ?? "ERROR"
                }
                print("Master code is \(game.masterCode.word)")
            }
        }
        
        .padding()
    }
    
    var codeLengthChooserAndRestarter: some View {
        HStack {
            Text("Word length")
                .foregroundStyle(.secondary)
            ForEach(3..<7) { length in
                Button("\(length)") {
                    withAnimation(.codeBreakerSlowEaseInOut) {
                        game.codeLength = length
                    } completion: {
                        withAnimation(.codeBreakerSlowEaseInOut) {
                            game.restart(codeLength: game.codeLength)
                            game.masterCode.pegs = (words.random(length: game.codeLength) ?? "await").map {String($0)}
                            selection = 0
                            print("Master code is :\(game.masterCode.word)")
                        }
                    }
                }
                .background(game.codeLength == length ? .blue.opacity(0.5) : .white, in: .capsule)
                .foregroundStyle(game.codeLength == length ? .black : .blue)
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
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
        }
    }
}

#Preview {
    CodeWordBreakerView()
}

