//
//  GameSettingsView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 28/01/26.
//

import SwiftUI

struct GameSettingsView: View {
    @Environment(\.gameSettings) var gameSettings
    
    var body: some View {
        NavigationStack {
            Form {
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
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GameSettingsView()
}



