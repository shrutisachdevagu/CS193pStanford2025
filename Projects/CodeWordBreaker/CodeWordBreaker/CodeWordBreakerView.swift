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
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                if !game.isOver {
                    view(for: game.guess )
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            HStack {
                resetButton
                Spacer()
                guessButton
            }
            .padding()
            .buttonStyle(.bordered)
            PegChooser { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.codeLength
            }
            
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                if !game.isGuessAlreadyAttempted() && !game.isGuessMissingPegs() {
                    game.attemptGuess()
                    selection = 0
                }
            }
        }
    }
    
    var resetButton: some View {
        Button("Restart") {
            game = CodeBreaker(codeLength: Int.random(in: 3...6))
            game.masterCode.pegs = (words.random(length: game.codeLength) ?? "await").map{String($0)}
            print("Master code is :\(game.masterCode.word)")
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code,selection: $selection)

        }
    }
}

#Preview {
    CodeWordBreakerView()
}

