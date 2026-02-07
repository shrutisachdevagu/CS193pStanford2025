//
//  CodeBreaker.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import Foundation


typealias Peg = String

@Observable
class CodeBreaker {
    var codeLength: Int
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let pegChoices: [Peg]
    var pegChoiceStatuses: [Peg: Match?] = [:]
    var lastPlayedTime: Date?
    
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
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
    
    func attemptGuess(){
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
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func resetGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = ""
    }
    
    func restart(codeLength: Int) {
        self.codeLength = codeLength
        self.attempts.removeAll()
        self.masterCode = Code(kind: .master(isHidden: true), codeLength: codeLength)
        self.guess = Code(kind: .guess, codeLength: codeLength)
        for pegChoice in pegChoices {
            self.pegChoiceStatuses[pegChoice] = nil
        }
        startTime = nil
        endTime = nil
        elapsedTime = 0
    }
    
    func startTimer() {
        print("timer STARTED - \(self.masterCode.word) & elapsed time is \(self.elapsedTime)")
        if !isOver && startTime == nil {
            startTime = Date.now
        }
    }
    
    func pauseTimer() {
        print("timer PAUSED - \(self.masterCode.word) & elapsed time is \(self.elapsedTime)")
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func isGuessAlreadyAttempted()->Bool {
        return attempts.contains {$0.pegs == guess.pegs}
    }
    
    func isGuessMissingPegs()->Bool {
        return guess.pegs.contains(Code.missingPeg)
    }
}


extension CodeBreaker: Equatable, Identifiable, Hashable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
