//
//  UIExtensions.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 12/01/26.
//

import SwiftUI

extension Color {
    static let unmatchAttemptPegColor = Color.red.opacity(0.3)
    static let exactMatchAttemptPegColor = Color.green.opacity(0.3)
    static let inexactMatchAttemptPegColor = Color.yellow.opacity(0.3)
    static let selectedGuessPegColor = Color.blue.opacity(0.3)
    static let unselectedGuessPegColor = Color.gray.opacity(0.02)
    static let hiddenMasterPegColor = Color.gray
    static let unhiddenMasterPegColor = Color.purple.opacity(0.3)
    static let pegChoicePegColor = Color.white
    static let neutralPegColor = Color.white
    
    static let unmatchAttemptPegChoiceColor = Color.red
    static let exactMatchAttemptPegChoiceColor = Color.green
    static let inexactMatchAttemptPegChoiceColor = Color.yellow
}


extension Animation {
    static let codeBreakerFastEaseInOut = Animation.easeInOut
    static let codeBreakerSlowEaseInOut = Animation.easeInOut(duration: 5)
    static let codeBreakerSlowBouncy = Animation.bouncy(duration: 5, extraBounce: 2)
}

struct PegShape {
    static let circularPegShape = Circle()
    static let roundedRectangularPegShape = RoundedRectangle(cornerRadius: 10)
    static let chosenPegShape = roundedRectangularPegShape
}
