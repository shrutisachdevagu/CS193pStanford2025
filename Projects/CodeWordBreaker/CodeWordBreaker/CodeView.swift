//
//  CodeView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code 
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self ){ index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        if selection == index && code.kind == .guess {
                            Selection.shape
                                .foregroundStyle(Selection.color.opacity(0.3))
                        } else {
                            Selection.shape
                                .foregroundStyle(Color.pink.opacity(0.3))
                        }
                    }
                    .overlay {
                        Selection.shape.foregroundStyle(code.isHidden ? .gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
        }
     }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let color : Color = Color.blue
        static let shape = RoundedRectangle(cornerRadius:  cornerRadius)
    }
}

#Preview {
    @Previewable @State var sel = 0
    return CodeView(code: CodeBreaker.dummyCode, selection: $sel)
}
