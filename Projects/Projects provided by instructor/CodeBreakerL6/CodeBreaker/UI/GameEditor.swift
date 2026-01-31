//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 24/01/26.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var game:CodeBreaker
    
    // MARK: Action Function
    var onDone: () -> Void?
    
    // MARK: Data Owned by Me
    @State private var showInvalidGameAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name",text: $game.name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .onSubmit { done()}
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $game.pegColorChoices)
                }
            }
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        done()
                    }
                    .alert("Invalid game", isPresented: $showInvalidGameAlert) {
                        Button("OK") {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("A game must have a name and more than 1 unique peg.")
                    }
                }
            }
        }
    }
    func done() {
        if game.isValid {
            onDone()
            dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable let game = CodeBreaker(name: "Preview ", pegChoices: [.pink,.purple,.mint,.cyan] )
    GameEditor(game: game, onDone: {print("done tapped")})
        .onChange(of: game.name) {
            print("game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("game peg choices changed to \(game.pegChoices)")
        }
}
