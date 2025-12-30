//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 29/12/25.
//

import Foundation

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let pegChoices: [Peg]
    let codeLength: Int
    
    init(pegChoices: [Peg] = ["red","green","blue","yellow"],codeLength: Int = 4){
        self.codeLength = codeLength
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master, codeLength: codeLength)
        masterCode.randomize(from: pegChoices)
        self.guess = Code(kind: .guess, codeLength: codeLength)
        print(masterCode)
    }
    
    mutating func attemptGuess(){
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExisingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExisingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    func isGuessAlreadyAttempted()->Bool {
        return attempts.contains {$0.pegs == guess.pegs}
    }
    func isGuessMissingPegs()->Bool {
        return guess.pegs.contains(Code.missing)
    }
}

struct Code {
    var kind: Kind
    var codeLength: Int
    var pegs: [Peg]
    static let missing: Peg = "clear"
    
    init(kind: Kind, codeLength: Int) {
        self.kind = kind
        self.codeLength = codeLength
        self.pegs = Array(repeating: Code.missing, count: codeLength)
    }
    
    enum Kind: Equatable{
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in 0..<codeLength {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches:[Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
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
}
