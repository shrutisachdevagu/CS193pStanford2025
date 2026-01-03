//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 20/12/25.
//

import SwiftUI

struct  CodeBreakerView: View {
    let themes = [
        "Standard" : ["red", "green", "yellow", "blue"],
        "Sky" : ["purple", "pink", "mint", "teal"],
        "Bold" : ["yellow", "brown", "orange", "black"],
        "Vehicles" : ["✈️", "🚜", "🛵", "🛺","🚁"],
        "Fruits" : ["🍎", "🍓", "🫐", "🍉","🍋"],
        "Faces" : ["😂", "🥳", "🫣", "😳","🥹","😡"]
    ]
    
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by me
    @State private var game = CodeBreaker(pegChoices: ["🍎", "🍓", "🫐", "🍉","🍋"],codeLength: Int.random(in: 3...6))
    @State private  var themeName = "Fruits"
    @State private var selection: Int = 0
    
    // MARK: - Body
     
    var body: some View {
        VStack {
            Text(themeName)
                .font(.largeTitle)
            view(for: game.masterCode)
            ScrollView {
                if !game.isOver {
                    view(for: game.guess )
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            resetButton
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.codeLength
            }
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
                    selection = 0
                }
            }
            print("random word = \(words.random(length: 5) ?? "none")")
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor )
    }
    
    var resetButton: some View {
        Button("Restart") {
            game = CodeBreaker(pegChoices: generateRandomPegChoices(),codeLength: Int.random(in: 3...6))
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code,selection: $selection)
            Color.clear
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
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize/maximumFontSize
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
    
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}
