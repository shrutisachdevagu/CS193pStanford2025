//
//  PegView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let pegType: PegType
    @Environment(\.gameSettings) var gameSettings
    
    // MARK: - Body
    
    var body: some View {
        gameSettings.shape()
            .stroke(.clear)
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .font(.title)
            }
            .background { // type of pegs - attempt, guess, selection
                gameSettings.shape()
                    .fill(Color.color(for: pegType))
            }
            .overlay { // hidding master code
                if pegType == .masterPeg(isHidden: true) {
                    gameSettings.shape()
                        .fill(Color.color(for: pegType))
                }
            }
    }
}

#Preview {
    PegView(peg: "R", pegType: .masterPeg(isHidden: true))
        .padding()
}

enum PegType: Equatable {
    case guessPeg(isSelected: Bool)
    case attemptPeg(matchType: Match)
    case pegChoicePeg
    case masterPeg(isHidden: Bool)
    case neutralPeg
}


