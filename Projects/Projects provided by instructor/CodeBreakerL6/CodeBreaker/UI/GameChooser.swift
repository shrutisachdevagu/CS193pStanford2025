//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 14/01/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data owned by me
    @State private var selection: CodeBreaker? = nil
    @State private var sortOption: GameList.SortOption = .name
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort by", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self ) { sortingOption in
                    Text(sortingOption.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(sortBy: sortOption, nameContains: searchText ,selection: $selection)
                .navigationTitle("Code Breaker")
                .searchable(text: $searchText, placement: .automatic, prompt: "Search")
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
