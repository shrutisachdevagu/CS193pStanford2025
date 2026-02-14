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
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            (lowerCaseSearch.isEmpty || game.name.contains(lowerCaseSearch) || game.name.contains(capitalizedSearch))
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker .name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
       
    }
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name:
                "Sort by Name"
            case .recent:
                "Recent"
            case .completed:
                "Completed"
            }
        }
    }
    
    var summarySize : GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnification
    }
    
    @State var staticSummarySize: GameSummary.Size = .large
    
    @State var dynamicSummarySizeMagnification: CGFloat = 1.0
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(size: summarySize, game: game)
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
        .gesture(summarySizeMagnifier)
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
        .task {
            await addSampleGames()
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
    
    func addSampleGames() async {
        
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let resultsCount = try? modelContext.fetchCount(fetchDescriptor), resultsCount == 0 {
            for url in sampleGameURLs {
                do {
                    let (json, _) = try await URLSession.shared.data(from: url)
                    let game = try JSONDecoder().decode(CodeBreaker.self, from: json)
                    modelContext.insert(game)
                    print("Loaded sample game from \(url) ")
                } catch {
                    print("Couldnt load sample game from json file at \(url).: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var sampleGameURLs: [URL] {
        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil).map {URL(fileURLWithPath: $0 )}
    }
    
    var summarySizeMagnifier: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnification = 1.0 
            }
    }
}

extension GameSummary.Size {
    static func * (lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.35: lhs.smaller.smaller
        case ...0.5: lhs.smaller
        default: lhs
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selectedGame :CodeBreaker? = CodeBreaker(name: "Sample", pegChoices: [.yellow,.black,.purple])
    NavigationStack {
        GameList(selection: $selectedGame)
    }
}
