//
//  CodeBreaker.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import Foundation


typealias Peg = String

struct CodeBreaker {
    var codeLength: Int
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let pegChoices: [Peg]
    var pegChoiceStatuses: [Peg: Match?] = [:]
    
    static var dummyCode: Code {
        var someCode = Code(kind: .guess, codeLength: 5)
        someCode.pegs = "DUMMY".map{String($0)}
        return someCode
    }
        
    init(codeLength: Int = 5){
        self.codeLength = codeLength
        self.pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        self.masterCode = Code(kind: .master(isHidden: true), codeLength: codeLength)
        self.guess = Code(kind: .guess, codeLength: codeLength)
        for pegChoice in pegChoices {
            self.pegChoiceStatuses[pegChoice] = nil
        }
    }
    
    var isOver: Bool {
        attempts.last?.pegs ==  masterCode.pegs
    }
    
    mutating func attemptGuess(){
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        for index in 0..<codeLength {
            let peg = attempt.pegs[index]
            let match = attempt.matches![index]
            if self.pegChoiceStatuses[peg] == nil {
                self.pegChoiceStatuses[peg] = match
            } else if self.pegChoiceStatuses[peg] == .inexact && match == .exact {
                self.pegChoiceStatuses[peg] = .exact
            }
        }
        guess.reset()
//        print(self.pegChoiceStatuses)
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func resetGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = ""
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
    
    mutating func restart() {
        self.codeLength = Int.random(in: 3...6)
//        self.codeLength = 5
        self.attempts.removeAll()
        self.masterCode = Code(kind: .master(isHidden: true), codeLength: codeLength)
        self.guess = Code(kind: .guess, codeLength: codeLength)
        for pegChoice in pegChoices {
            self.pegChoiceStatuses[pegChoice] = nil
        }
        
    }
}


