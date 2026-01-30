//
//  ElapsedTimerView.swift
//  CodeWordBreaker
//
//  Created by Shruti Sachdeva on 30/01/26.
//

import SwiftUI

struct ElapsedTimerView: View {
    let startTime: Date?
    let endTime: Date?
    var elapsedTime: TimeInterval = 0
    var format: SystemFormatStyle.DateOffset{
        .offset(to: startTime! - elapsedTime, allowedFields: [.minute,.second])
    }
    
    var body: some View {
        if startTime != nil {
            if let endTime {
                Text(endTime, format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        } else {
            Image(systemName: "pause")
        }
    }
}

#Preview {
    ElapsedTimerView(startTime: .now, endTime: .distantFuture)
}
