//
//  PegChooser.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: Data In
    let pegChoiceStatuses: [Peg: Match?]
    @Environment(\.gameSettings) var gameSettings
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    let onDelete: (() -> Void)?
    let onGuess: (() -> Void)?

    // MARK: - Body
    var body: some View {
        VStack {
            keyboardRow1
            keyboardRow2
            keyboardRow3
        }
    }

    var keyboardRow1: some View {
        HStack {
            ForEach(KeyboardKeys.row1, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg,pegType: .pegChoicePeg)
                }
                .foregroundStyle(colorFor(peg: peg))
            }
        }
        .aspectRatio(10/3, contentMode: .fit)
    }
    
    var keyboardRow2: some View {
        HStack {
            ForEach(KeyboardKeys.row2, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg, pegType: .pegChoicePeg)
                }
                .foregroundStyle(colorFor(peg: peg))
            }
        }
        .aspectRatio(10/3, contentMode: .fit)
    }
    
    var keyboardRow3: some View {
        HStack {
            deleteButton
                .buttonStyle(.glass)
            ForEach(KeyboardKeys.row3, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg, pegType: .pegChoicePeg)
                }
                .foregroundStyle(colorFor(peg: peg))
            }
            guessButton
                .buttonStyle(.glass)
        }
        .labelStyle(.iconOnly)
        .aspectRatio(10/3, contentMode: .fit)
    }

    var deleteButton: some View {
        Button {
            onDelete?()
        } label: {
            Label {
                Text("Delete")
            } icon: {
                Image(systemName: "delete.backward.fill")
            }
        }
        .labelStyle(.iconOnly)
    }
    
    var guessButton: some View {
        Button {
            onGuess?()
        } label: {
            Label {
                Text("Delete")
            } icon: {
                Image(systemName: "return")
            }
        }
    }
    
    struct KeyboardKeys {
        static let row1: [Peg] = "QWERTYUIOP".map { String($0) }
        static let row2: [Peg] = "ASDFGHJKLZ".map { String($0) }
        static let row3: [Peg] = "XCVBNM".map { String($0) }
    }
    
    func colorFor(peg choice: Peg) -> Color {
        let status = pegChoiceStatuses[choice]
        switch status {
        case .exact: return gameSettings.exactMatchAttemptPegChoiceColor
        case .inexact: return gameSettings.inexactMatchAttemptPegChoiceColor
        case .noMatch: return gameSettings.unmatchAttemptPegChoiceColor
        default: return .accentColor
        }
    }
}

#Preview {
    PegChooser(pegChoiceStatuses: [:], onChoose: {_ in print("Choosing")}, onDelete: {print("Deleting")}, onGuess: {print("Guessing")})
}
