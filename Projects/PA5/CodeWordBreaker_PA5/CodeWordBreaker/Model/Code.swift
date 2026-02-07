//
//  Code.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import Foundation
import SwiftData

enum Match: String {
    case noMatch
    case exact
    case inexact
}

@Model class Code {
    var kind: Kind {
        get { Kind(_kind)}
        set { _kind = newValue.description }
    }
    
    var _kind: String = Kind.unknown.description
    var codeLength: Int
    var pegs: [Peg]
    var timestamp = Date.now

    static let missingPeg: Peg = ""
    
    init(kind: Kind, codeLength: Int) {
        self.codeLength = codeLength
        self.pegs = Array(repeating: Code.missingPeg, count: codeLength)
        self.kind = kind
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    var matches:[Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    var word: String {
        get {
            pegs.joined()
        }
        set {
            pegs = newValue.map{String($0)}
        }
    }
    
    func reset(){
        pegs = Array(repeating: Code.missingPeg, count: codeLength)
    }
    
    func match(against otherCode:Code)->[Match] {
        // MARK: - Declarative code for func match
        var pegsToMatch = otherCode.pegs
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .noMatch
            }
        }
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    pegsToMatch.remove(at: matchIndex)
                    return .inexact
                }
            else {
                return exactMatches[index]
            }
        }
        /// Imperative code for func match
        /*
        func match(against otherCode:Code)->[Match] {
            var results: [Match] = Array(repeating: .noMatch, count: pegs.count)
            var pegsToMatch = otherCode.pegs
            for index in pegs.indices.reversed() {
                if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                    results[index] = .exact
                    pegsToMatch.remove(at: index)
                }
            }
            
            for index in pegs.indices {
                if results[index] != .exact {
                    if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                        results[index] = .inexact
                        pegsToMatch.remove(at: matchIndex)
                    }
                }
            }
            return results
        }
        */
    }
}
