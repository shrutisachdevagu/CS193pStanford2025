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
    let isSummaryCode: Bool
    var onSummaryCodeTap: ()-> Void?
    @Environment(\.gameSettings) var gameSettings
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data owned by me
    @Namespace private var selectionNamespace
    
    init(code: Code, selection: Binding<Int> = .constant(-1),isSummaryCode: Bool = false, onSummaryCodeTap: @escaping () -> Void? = {nil}) {
        self.code = code
        self._selection = selection
        self.isSummaryCode = isSummaryCode
        self.onSummaryCodeTap = onSummaryCodeTap
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self ){ index in
                PegView(peg: code.pegs[index], pegType: getPegTypeFromCodeAt(index: index))
                    .padding(Selection.border)
                    .background {
                        if isSummaryCode {
                            gameSettings.shape().fill(.ultraThinMaterial)
                        }
                    }
                    .onTapGesture {
                        if isSummaryCode {
                           onSummaryCodeTap()
                        }
                        else if code.kind == .guess {
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
            return .masterPeg(isHidden: isHidden)
        case .guess:
            return .guessPeg(isSelected: selection == index)
        case .attempt(let matches):
            return .attemptPeg(matchType: matches[index])
        case .unknown:
            return .neutralPeg
        }
    }
}

#Preview {
    @Previewable @State var sel = 0
    return CodeView(code: CodeBreaker.dummyCode, selection: $sel)
}
