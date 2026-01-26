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
    
    // MARK: Data owned by me
    let pegShape = RoundedRectangle(cornerRadius: 7)
    
    // MARK: - Body
    
    var body: some View {
        pegShape
            .stroke(.clear)
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .font(.title)
            }
            .background { // type of pegs - attempt, guess, selection
                RoundedRectangle(cornerRadius: 7)
                    .fill(pegType.colorForPegType())
            }
            .overlay { // hidding master code
                if pegType == .masterPeg(isHidden: true) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(pegType.colorForPegType())
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
    
    func colorForPegType()->Color {
        switch self {
        case .attemptPeg(let matchType):
            switch matchType {
            case .noMatch:
                return .unmatchAttemptPegColor
            case .exact:
                return .exactMatchAttemptPegColor
            case .inexact:
                return .inexactMatchAttemptPegColor
            }
        case .guessPeg(let isSelected):
            switch isSelected {
            case true:
                return .selectedGuessPegColor
            case false:
                return .unselectedGuessPegColor
            }
        case .pegChoicePeg:
            return .pegChoicePegColor
        case .masterPeg(let isHidden):
            switch isHidden {
            case true:
                return .hiddenMasterPegColor
            case false:
                return .unhiddenMasterPegColor
            }
        case .neutralPeg:
            return .neutralPegColor
        }
    }
}


