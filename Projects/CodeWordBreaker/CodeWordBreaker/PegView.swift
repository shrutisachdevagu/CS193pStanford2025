//
//  PegView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 05/01/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 7)
    
    var body: some View {
        pegShape
            .stroke(.clear)
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .font(.title)
            }
        }
}

#Preview {
    PegView(peg: "R")
        .padding()
}
