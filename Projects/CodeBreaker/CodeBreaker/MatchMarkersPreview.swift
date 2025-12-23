//
//  MatchMarkersPreview.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 23/12/25.
//
import SwiftUI

struct MatchMarkersPreview:View {
    var pegs:Int {
        matches.count
    }
    var matches:[Match]
    var dummyPegs:some View {
        ForEach(0..<pegs) { _ in
            Circle().fill()
                
        }
    }
    var body: some View {
        HStack {
            dummyPegs
                .aspectRatio(1, contentMode: .fit)

            MatchMarkers(matches: matches)
        }
        .padding()
    }
}

#Preview {
    VStack {
        MatchMarkersPreview(matches: [.exact,.exact,.inexact])
        MatchMarkersPreview(matches: [.exact,.noMatch,.inexact])
        MatchMarkersPreview(matches: [.exact,.noMatch,.exact,.inexact])
        MatchMarkersPreview(matches: [.exact,.exact,.exact,.noMatch,.inexact])
        MatchMarkersPreview(matches: [.exact,.exact,.inexact,.noMatch,.inexact])
        MatchMarkersPreview(matches: [.exact,.exact,.inexact,.noMatch,.exact])
        MatchMarkersPreview(matches: [.exact,.exact,.inexact,.noMatch,.exact,.exact])

    }
}
