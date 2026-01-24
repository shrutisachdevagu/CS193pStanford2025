//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 24/01/26.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game:CodeBreaker
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name",text: $game.name)
            }
            Section("Pegs") {
                List {
                    ForEach(game.pegChoices.indices, id: \.self) { index in
                        ColorPicker(selection: $game.pegChoices[index]) {
                            Text("Peg Choice \(index + 1)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable let game = CodeBreaker(name: "Preview ", pegChoices: [.pink,.purple,.mint,.cyan])
    GameEditor(game: game)
        .onChange(of: game.name) {
            print("game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices) {
            print("game peg choices changed to \(game.pegChoices)")
        }
}
