//
//  PegView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

enum PegType {
    case selectedGuessPeg
    case unselectedGuessPeg
    case hiddenMasterCodePeg
    case unhiddenMasterCodePeg
    case exactMatchAttemptPeg
    case inexactMatchAttemptPeg
    case noMatchAttemptPeg
    case pegChoice
    case none
    
    func colorForPegType()->Color {
        switch self {
        case .exactMatchAttemptPeg:
            return .green
        case .selectedGuessPeg:
            return .blue
        case .unselectedGuessPeg:
            return .gray.opacity(0.01)
        case .hiddenMasterCodePeg:
            return .clear
        case .unhiddenMasterCodePeg:
            return .indigo
        case .inexactMatchAttemptPeg:
            return .yellow
        case .noMatchAttemptPeg:
            return .red
        case .pegChoice:
            return .clear
        case .none:
            return .clear
        }
    }
}

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
            .background {
                RoundedRectangle(cornerRadius: 7)
                    .fill(pegType.colorForPegType().opacity(0.3))
            }
            .padding(pegType == .unselectedGuessPeg ? 5 : 0)
            .overlay {
                Group {
                    if pegType == .hiddenMasterCodePeg {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(.gray)
                    }
                }
                .animation(nil, value: pegType)
            }
        }
}

#Preview {
    PegView(peg: "R",pegType: .exactMatchAttemptPeg)
        .padding()
}
