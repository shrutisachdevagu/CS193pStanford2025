//
//  PegChoiceStatuses.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 07/02/26.
//

import Foundation

struct PegChoiceStatuses: Equatable, CustomStringConvertible {
    private var statuses: [Peg: Match?]
    
    // MARK: - Initialization
    
    init(_ dictionary: [Peg: Match?]) {
        self.statuses = dictionary
    }
    
    init() {
        var statuses = [Peg: Match?]()
        for peg in "QWERTYUIOPASDFGHJKLZXCVBNM".map({ String($0) }) {
            statuses[peg] = nil
        }
        self.statuses = statuses
    }
    
    init(fromPegChoices pegChoices: [Peg]) {
        var statuses = [Peg: Match?]()
        for pegChoice in pegChoices {
            statuses[pegChoice] = nil
        }
        self.statuses = statuses
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        statuses.map { peg, match in
            if let match = match {
                return "\(peg):\(match.rawValue)"
            } else {
                return "\(peg):nil"
            }
        }.joined(separator: "|")
    }
    
    // MARK: - Non-Failable Initializer from String
    
    init(_ string: String) {
        guard !string.isEmpty else {
            self.statuses = [:]
            return
        }
        
        var result = [Peg: Match?]()
        let pairs = string.split(separator: "|")
        
        for pair in pairs {
            let components = pair.split(separator: ":")
            guard components.count == 2 else { continue }
            
            let peg = String(components[0])
            let matchString = String(components[1])
            
            if matchString == "nil" {
                result[peg] = nil
            } else if let match = Match(rawValue: matchString) {
                result[peg] = match
            }
        }
        
        self.statuses = result
    }
    
    // MARK: - Dictionary-like Access
    
    subscript(peg: Peg) -> Match?? {
        get { statuses[peg] }
        set { statuses[peg] = newValue }
    }
    
    var keys: Dictionary<Peg, Match?>.Keys {
        statuses.keys
    }
    
    var values: Dictionary<Peg, Match?>.Values {
        statuses.values
    }
    
    mutating func removeAll() {
        statuses.removeAll()
    }
}
