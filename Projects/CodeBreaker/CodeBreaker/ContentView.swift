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
            Image(systemName: "globe")
            Text("Welcome to CS193p!")
                .foregroundStyle(.green)
            Text("Greetings")
            Circle()
        }
        .padding()
        .font(.largeTitle)
    }
}

#Preview {
    ContentView()
}
