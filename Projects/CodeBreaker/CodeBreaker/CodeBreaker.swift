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
        self.masterCode = Code(kind: .master(isHidden: true), codeLength: codeLength)
        masterCode.randomize(from: pegChoices)
        self.guess = Code(kind: .guess, codeLength: codeLength)
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs ==  masterCode.pegs
    }
    
    mutating func attemptGuess(){
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExisingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExisingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
    
    func isGuessAlreadyAttempted()->Bool {
        return attempts.contains {$0.pegs == guess.pegs}
    }
    func isGuessMissingPegs()->Bool {
        return guess.pegs.contains(Code.missingPeg)
    }
}


