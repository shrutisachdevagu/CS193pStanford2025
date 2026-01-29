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
    var pegShape: PegShape
    
    static let shared = GameSettings()
    
    var codeLength: Int
    
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
}

extension EnvironmentValues {
    @Entry var gameSettings: GameSettings = GameSettings.shared
}
