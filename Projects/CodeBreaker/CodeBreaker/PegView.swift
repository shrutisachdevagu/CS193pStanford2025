//
//  PegView.swift
//  CodeBreaker
//
//  Created by Shruti Sachdeva on 02/01/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(.gray)
                }
                if Color(name: peg) == nil {
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9/120)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(Color(name: peg ) ?? .white)    }
}

#Preview {
    PegView(peg: "orange ")
        .padding()
}
