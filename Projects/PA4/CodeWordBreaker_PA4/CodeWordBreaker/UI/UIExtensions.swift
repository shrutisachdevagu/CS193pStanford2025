//
//  UIExtensions.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 12/01/26.
//

import SwiftUI

extension Color {
    static func color(for peg: PegType) -> Color {
        switch peg {
        case .attemptPeg(let matchType):
            switch matchType {
            case .noMatch:
                return GameSettings.shared.unmatchAttemptPegColor
            case .exact:
                return GameSettings.shared.exactMatchAttemptPegColor
            case .inexact:
                return GameSettings.shared.inexactMatchAttemptPegColor
            }
        case .guessPeg(let isSelected):
            switch isSelected {
            case true:
                return GameSettings.shared.selectedGuessPegColor
            case false:
                return GameSettings.shared.unselectedGuessPegColor
            }
        case .pegChoicePeg:
            return GameSettings.shared.pegChoicePegColor
        case .masterPeg(let isHidden):
            switch isHidden {
            case true:
                return GameSettings.shared.hiddenMasterPegColor
            case false:
                return GameSettings.shared.unhiddenMasterPegColor
            }
        case .neutralPeg:
            return GameSettings.shared.neutralPegColor
        }
    }
}


extension Animation {
    static let codeBreakerFastEaseInOut = Animation.easeInOut
    static let codeBreakerSlowEaseInOut = Animation.easeInOut(duration: 5)
    static let codeBreakerSlowBouncy = Animation.bouncy(duration: 5, extraBounce: 2)
}



