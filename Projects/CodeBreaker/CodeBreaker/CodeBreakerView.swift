//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 20/12/25.
//

import SwiftUI

struct  CodeBreakerView: View {
    let themes = [
        "Standard":["red","green","yellow","blue"],
        "Sky":["purple","pink","mint","teal"],
        "Bold":["yellow","brown","orange","black"],
        "Vehicles":["✈️","🚜","🛵","🛺"],
        "Fruits":["🍎","🍓","🫐","🍉"],
        "Faces":["😂","🥳","🫣","😳"]
    ]
    @State var game = CodeBreaker(pegChoices: ["🍎","🍓","🫐","🍉"],codeLength: Int.random(in: 3...6))
    @State var themeName = "Fruits"
    var body: some View {
        VStack {
            Text(themeName)
                .font(.largeTitle)
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess )
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            resetButton
        }
        .padding()
        .onAppear {
            game = CodeBreaker(pegChoices: generateRandomPegChoices(),codeLength: Int.random(in: 3...6))
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                if !game.isGuessAlreadyAttempted() && !game.isGuessMissingPegs() {
                    game.attemptGuess()
                }
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var resetButton: some View {
        Button("Restart") {
            game = CodeBreaker(pegChoices: generateRandomPegChoices(),codeLength: Int.random(in: 3...6))
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self ){ index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missingPeg {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.gray)
                        }
                        if Color(name: code.pegs[index]) == nil {
                            Text(code.pegs[index])
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(Color(name: code.pegs[index]) ?? .white)
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            Rectangle()
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers(matches: matches )
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
         }
    }
    
    func generateRandomPegChoices()->[Peg] {
        themeName = themes.keys.randomElement()!
        return themes[themeName]!
    }
}

#Preview {
    CodeBreakerView()
}


extension Color {
    /// Dictionary mapping color names to SwiftUI Colors
    private static let nameToColor:[String : Color] = [
        "black": .black,
        "white": .white,
        "gray": .gray,
        "red": .red,
        "green": .green,
        "blue": .blue,
        "orange": .orange,
        "yellow": .yellow,
        "pink": .pink,
        "purple": .purple,
        "brown": .brown,
        "cyan": .cyan,
        "mint": .mint,
        "indigo": .indigo,
        "teal": .teal,
        "clear": .clear
    ]
    /// Failable initializer that creates a Color from its name
    init?(name:String) {
        let lowercased = name.lowercased()
        guard let color = Color.nameToColor[lowercased] else {
            return nil
        }
        self = color
    }
    /// Inverse lookup: returns the name of the color if known
    var name:String? {
        Color.nameToColor.first {$0.value == self}?.key
    }
}
