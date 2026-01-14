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
    
    // MARK: Data owned by me
    @Namespace private var selectionNamespace
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self ){ index in
                PegView(peg: code.pegs[index], pegType: getPegTypeFromCodeAt(index: index))
                    .padding(Selection.border)
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
    
    func getPegTypeFromCodeAt(index:Int) -> PegType {
        switch code.kind {
        case .master(let isHidden):
            return isHidden ? .hiddenMasterCodePeg : .unhiddenMasterCodePeg
        case .guess:
            return selection == index ? .selectedGuessPeg : .unselectedGuessPeg
        case .attempt(let array):
            switch array[index] {
            case .exact:
                return .exactMatchAttemptPeg
            case .inexact:
                return .inexactMatchAttemptPeg
            case .noMatch:
                return .noMatchAttemptPeg
            }
        case .unknown:
            return .none
        }
    }
}

#Preview {
    @Previewable @State var sel = 0
    return CodeView(code: CodeBreaker.dummyCode, selection: $sel)
}
