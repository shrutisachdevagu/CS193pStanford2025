//
//  GameList.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 24/01/26.
//

import SwiftUI

struct GameList: View {
    // MARK: Date shared with Me
    @Binding var selection: CodeBreaker?
    
    // MARK: Date Owned by Me
    @State private var games: [CodeBreaker] = []
    @State private var showGameEditor: Bool = false
    @State private var gameToEdit: CodeBreaker?
    
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
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offset, index in
                games.move(fromOffsets: offset, toOffset: index)
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
    
    func deleteButton(for game: CodeBreaker)-> some View{
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll{$0 == game}
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
            showGameEditor = true
        }
        .onChange(of: gameToEdit) {
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil }) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor:some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
            }
        }
    }
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan, .yellow]))
            selection = games.first
        }
    }
}

#Preview {
    @Previewable @State var selectedGame :CodeBreaker? = CodeBreaker(name: "Sample", pegChoices: [.yellow,.black,.purple])
    NavigationStack {
        GameList(selection: $selectedGame)
    }
}
