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

    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                ForEach(KeyboardKeys.row1, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg,pegType: .pegChoice)
                    }
                }
            }
            .aspectRatio(20/3, contentMode: .fit)
            HStack {
                ForEach(KeyboardKeys.row2, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg, pegType: .pegChoice)
                    }
                }
            }
            .aspectRatio(20/3, contentMode: .fit)
            HStack {
                ForEach(KeyboardKeys.row3, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg, pegType: .pegChoice)
                    }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }

    struct KeyboardKeys {
        static let row1: [Peg] = "QWERTYUIOP".map { String($0) }
        static let row2: [Peg] = "ASDFGHJKLZ".map { String($0) }
        static let row3: [Peg] = "XCVBNM".map { String($0) }
    }
}

#Preview {
    PegChooser{ peg in
        print(peg)
    }
}
