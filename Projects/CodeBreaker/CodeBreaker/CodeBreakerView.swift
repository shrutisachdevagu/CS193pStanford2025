//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 20/12/25.
//

import SwiftUI

struct  CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: Bool.random() ? ["➕","🚜","🏀","🌈"] : ["orange","brown","black","yellow"],codeLength: Int.random(in: 3...6))
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess )
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            resetButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                if !game.isGuessAlreadyAttempted() && !game.isGuessMissingPegs() {
                    game.attemptGuess()
                }
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var resetButton: some View {
        Button("Restart") {
            game = CodeBreaker(pegChoices: generateRandomPegChoices(),codeLength: Int.random(in: 3...6))
        }
    }
    
    func color(for peg: Peg)->Color{
        switch peg {
        case "yellow":
                .yellow
        case "red":
                .red
        case "orange":
                .orange
        case "black":
                .black
        case "brown":
                .brown
        case "green":
                .green
        case "blue":
                .blue
        default:
                .white
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self ){ index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.gray)
                        }
                        if color(for: code.pegs[index]) == .white {
                            Text(code.pegs[index])
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(color(for: code.pegs[index]))
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
    
    func generateRandomPegChoices()->[Peg] {
        if Bool.random() {
            return ["➕","🚜","🏀","🌈"]
        } else {
            return ["orange","brown","black","yellow"]
        }
    }
}

#Preview {
    CodeBreakerView()
}
