//
//  GameList.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 24/01/26.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Date shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    // MARK: Date Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    
    init(sortBy:SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        let lowerCaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let predicate = #Predicate<CodeBreaker> { game in
            lowerCaseSearch.isEmpty || game.name.contains(lowerCaseSearch) || game.name.contains(capitalizedSearch)
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker .name)
        case .recent: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
       
    }
    enum SortOption: CaseIterable {
        case name
        case recent
        
        var title: String {
            switch self {
            case .name:
                "Sort by Name"
            case .recent:
                "Recent"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    editButton(for: game)
                        .tint(.accentColor)
                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton()  // editing the game list
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    var showGameEditor:Binding<Bool> {
        Binding<Bool> {
            gameToEdit != nil
        } set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        }

    }
    func deleteButton(for game: CodeBreaker)-> some View{
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton:some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor:some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                 }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    func addSampleGames() {
        
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let resultsCount = try? modelContext.fetchCount(fetchDescriptor), resultsCount == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            modelContext.insert(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan, .yellow]))
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selectedGame :CodeBreaker? = CodeBreaker(name: "Sample", pegChoices: [.yellow,.black,.purple])
    NavigationStack {
        GameList(selection: $selectedGame)
    }
}
