//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 20/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, content: defaultView)
    }
    
    @ViewBuilder
    func defaultView()->some View {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Text("Hello, world!")
            .font(.largeTitle)
    }
}

#Preview {
    ContentView()
}
