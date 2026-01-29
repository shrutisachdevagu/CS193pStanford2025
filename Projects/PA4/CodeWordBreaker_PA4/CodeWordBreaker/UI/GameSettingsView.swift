//
//  GameSettingsView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 28/01/26.
//

import SwiftUI

struct GameSettingsView: View {
    @Environment(\.gameSettings) var gameSettings
    @State var exactColor: Color
    @State var inexactColor: Color
    @State var noMatchColor: Color
    @State var winMatchColor: Color
    init(exactColor: Color = GameSettings.shared.exactMatchAttemptPegChoiceColor, inexactColor: Color = GameSettings.shared.inexactMatchAttemptPegChoiceColor, noMatchColor: Color = GameSettings.shared.unmatchAttemptPegChoiceColor, winMatchColor: Color = GameSettings.shared.unhiddenMasterPegColor) {
        self.exactColor = exactColor
        self.inexactColor = inexactColor
        self.noMatchColor = noMatchColor
        self.winMatchColor = winMatchColor
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Peg Shape")
                        Spacer()
                        Circle()
                            .fill(.gray.opacity(0.5))
                            .strokeBorder(gameSettings.pegShape == .circle ? .blue : .clear, lineWidth: 3)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: 50)
                            .onTapGesture {
                                gameSettings.pegShape = .circle
                            }
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.5))
                            .strokeBorder(gameSettings.pegShape == .rect ? .blue : .clear, lineWidth: 3)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: 50)
                            .onTapGesture {
                                gameSettings.pegShape = .rect
                            }
                    }
                }
                
                HStack {
                    Text("Word Length")
                    Spacer()
                    ForEach(3..<7) { index in
                        Text(index, format: .number)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray.opacity(0.5))
                                    .strokeBorder(gameSettings.codeLength == index ? .blue : .clear, lineWidth: 3)
                                
                            }
                            .onTapGesture {
                                gameSettings.codeLength = index
                            }
                            
                    }
                }
                
                Section("Colors") {
                    HStack {
                        ColorPicker("Exact match", selection: $exactColor)
                        PegView(peg: Peg("A"), pegType: .attemptPeg(matchType: .exact))
                            .frame(maxHeight: 50)
                    }
                    HStack {
                        ColorPicker("Inexact match", selection: $inexactColor)
                        PegView(peg: Peg("A"), pegType: .attemptPeg(matchType: .inexact))
                            .frame(maxHeight: 50)
                    }
                    HStack {
                        ColorPicker("No match", selection: $noMatchColor)
                        PegView(peg: Peg("A"), pegType: .attemptPeg(matchType: .noMatch))
                            .frame(maxHeight: 50)
                    }
                    HStack {
                        ColorPicker("Win match", selection: $winMatchColor)
                        PegView(peg: Peg("A"), pegType: .masterPeg(isHidden: false))
                            .frame(maxHeight: 50)
                    }
                }
                
            }
            .onChange(of: exactColor) {
                gameSettings.exactMatchAttemptPegChoiceColor = exactColor
            }
            .onChange(of: inexactColor) {
                gameSettings.inexactMatchAttemptPegChoiceColor = inexactColor
            }
            .onChange(of: noMatchColor) {
                gameSettings.unmatchAttemptPegChoiceColor = noMatchColor
            }
            .onChange(of: winMatchColor) {
                gameSettings.unhiddenMasterPegColor = winMatchColor
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GameSettingsView()
}



