//
//  PegChooser.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct PegChooser: View {
        
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    let choicesRow1: [Peg] = "QWERTYUIOP".map { String($0) }
    let choicesRow2: [Peg] = "ASDFGHJKLZ".map { String($0) }
    let choicesRow3: [Peg] = "XCVBNM".map { String($0) }
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                ForEach(choicesRow1, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            .aspectRatio(20/3, contentMode: .fit)
            HStack {
                ForEach(choicesRow2, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            .aspectRatio(20/3, contentMode: .fit)
            HStack {
                ForEach(choicesRow3, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }
}

#Preview {
    PegChooser{ peg in
        print(peg)
    }
}
