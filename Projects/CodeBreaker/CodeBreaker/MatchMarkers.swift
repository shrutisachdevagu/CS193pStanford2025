//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 21/12/25.
//

import SwiftUI
 
enum Match {
    case noMatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    
    // MARK: Data In
    
    let matches:[Match]
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
            if matches.count > 4 {
                VStack {
                    matchMarker(peg: 4)
                    matchMarker(peg: 5)
                }
            }
        }
    }
    
    func matchMarker(peg: Int)->some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .noMatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact,.inexact,.noMatch])
}
