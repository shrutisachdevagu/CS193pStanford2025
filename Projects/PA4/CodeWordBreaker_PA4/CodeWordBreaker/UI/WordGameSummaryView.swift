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
    
    var onSummaryCodeTap: () -> Void?
    
    init(game: CodeBreaker, onSummaryCodeTap: @escaping () -> Void? = {nil}) {
        self.game = game
        self.onSummaryCodeTap = onSummaryCodeTap
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("^[\(game.codeLength) letter](inflect: true)")
                    .font(.title)
                
                if game.isOver {
                    Spacer()
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(GameSettings.shared.unhiddenMasterPegColor)
                }
            }
            if game.attempts.isEmpty {
                CodeView(code: game.guess, isSummaryCode: true, onSummaryCodeTap: onSummaryCodeTap)
            } else {
                CodeView(code: game.attempts.last!, isSummaryCode: true, onSummaryCodeTap: onSummaryCodeTap)
            }
            HStack {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
                Spacer()
                Text(Duration.seconds(game.elapsedTime.rounded()).formatted())
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
