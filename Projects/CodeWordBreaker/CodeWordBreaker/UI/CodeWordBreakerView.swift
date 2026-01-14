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
//    @State private var tempStatus = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
                .animation(nil, value: game.codeLength)

            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
                .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .trailing)))
            }
            HStack {
                resetButton
                Spacer()
                guessButton
                    .disabled(game.isOver)
            }
            .padding()
            .buttonStyle(.bordered)
            PegChooser { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.codeLength
            }
            .disabled(game.isOver)
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
    
    var guessButton: some View {
        Button("Guess") {
            print("Guess is \(game.guess.word) and \(checker.isAWord(game.guess.word.lowercased()) ? "its" : "its not") a valid word")
            
            withAnimation(.codeBreakerSlow) {
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
    }
    
    var resetButton: some View {
        Button("Restart") {
            withAnimation(.codeBreakerSlow) {
                game.restart()
                game.masterCode.pegs = (words.random(length: game.codeLength) ?? "await").map {String($0)}
                selection = 0
                print("Master code is :\(game.masterCode.word)")
            }
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

