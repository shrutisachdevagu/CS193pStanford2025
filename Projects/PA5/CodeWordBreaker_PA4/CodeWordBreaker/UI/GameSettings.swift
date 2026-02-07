//
//  GameSettings.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 29/01/26.
//

import SwiftUI

enum PegShape {
    case circle
    case rect
}

@Observable
class GameSettings {
    static var shared = GameSettings()

    var pegShape: PegShape
    var codeLength: Int
    
    var unmatchAttemptPegColor: Color {unmatchAttemptPegChoiceColor.opacity(0.3)}
    var exactMatchAttemptPegColor: Color {exactMatchAttemptPegChoiceColor.opacity(0.3)}
    var inexactMatchAttemptPegColor:Color {inexactMatchAttemptPegChoiceColor.opacity(0.3)}
    var selectedGuessPegColor = Color.blue.opacity(0.3)
    var unselectedGuessPegColor = Color.gray.opacity(0.02)
    var hiddenMasterPegColor = Color.gray
    var unhiddenMasterPegColor = Color.purple.opacity(0.3)
    var pegChoicePegColor = Color.white
    var neutralPegColor = Color.white
    
    var unmatchAttemptPegChoiceColor = Color.red
    var exactMatchAttemptPegChoiceColor = Color.green
    var inexactMatchAttemptPegChoiceColor = Color.yellow
    
    init(pegShape: PegShape = .rect, codeLength: Int = 5) {
        self.pegShape = pegShape
        self.codeLength = codeLength
    }
    
    func shape() -> some Shape {
        switch pegShape {
        case .circle:
            AnyShape(Circle())
        case .rect:
            AnyShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    static func loadGSCodeLengthFromDefaults() {
        UserDefaults.standard.register(defaults: ["GSCodeLength":5])
        shared.codeLength = UserDefaults.standard.integer(forKey: "GSCodeLength")
    }
    
    static func saveGSCodeLengthIntoDefaults() {
        UserDefaults.standard.set(shared.codeLength, forKey: "GSCodeLength")
    }
}

extension EnvironmentValues {
    @Entry var gameSettings: GameSettings = GameSettings.shared
}
