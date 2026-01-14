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
    static let unhiddenMasterPegColor = Color.pink.opacity(0.3)
    static let pegChoicePegColor = Color.white
    static let neutralPegColor = Color.cyan
}


extension Animation {
    static let codeBreakerFast = Animation.easeInOut
    static let codeBreakerSlow = Animation.easeInOut(duration: 5)
}
