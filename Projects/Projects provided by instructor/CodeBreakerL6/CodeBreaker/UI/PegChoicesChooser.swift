//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 25/01/26.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data shared with me
    @Binding var pegChoices:[Color]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(selection: $pegChoices[index]) {
                    button("Peg Choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            
            button("Add Peg", systemImage: "plus.circle",color: .green) {
                pegChoices.append(.gray)
            }
        }
    }
    
    
    func button(_ title: String, systemImage: String, color: Color? = nil, action: @escaping () -> Void ) -> some View {
        HStack {
            Button{
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices : [Color] = [.red,.green,.blue]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) { oldValue, newValue in
            print("PegChoices changed to \(newValue)")
        }
}
