//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 20/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red,.green,.yellow,.blue])
            pegs(colors: [.green,.yellow,.yellow,.blue])
            pegs(colors: [.blue,.red,.blue,.blue ])
        }
        .padding()
    }
    
    func pegs(colors: Array<Color>) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self ){ index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact,.exact,.inexact,.noMatch ])
        }
    }
}

#Preview {
    ContentView()
}
