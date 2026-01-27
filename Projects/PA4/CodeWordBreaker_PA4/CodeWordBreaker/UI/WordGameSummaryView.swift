//
//  WordGameSummaryView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 26/01/26.
//

import SwiftUI

struct WordGameSummaryView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("^[\(game.codeLength) letter](inflect: true)")
                .font(.title)
            if game.attempts.isEmpty {
                CodeView(code: game.guess, selection: .constant(0))
            } else {
                CodeView(code: game.attempts.last!)
            }
            HStack {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
                Spacer()
                Text(game.lastPlayedTime?.formatted(date: .abbreviated, time: .shortened) ?? "--")
            }
        }
    }
}

#Preview {
    @Previewable @State var game : CodeBreaker = CodeBreaker(codeLength: 5)
    game.masterCode.word = "GREAT"
//    game.guess.word = "THEIR"
//    game.attemptGuess()
//    game.guess.word = "THERE"
//    game.attemptGuess()
    return WordGameSummaryView(game: game)
}
