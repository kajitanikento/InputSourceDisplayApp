//
//  PomodoroTimerView.swift
//  InputSourceDisplayApp
//
//  Created by kajitani kento on 2025/12/14.
//

import SwiftUI
import ComposableArchitecture

struct PomodoroTimerView: View {
    static let size: CGSize = .init(width: 100, height: 36)
    
    @Bindable var store: StoreOf<PomodoroTimer>
    
    var body: some View {
        if let timerText {
            timerText
                .font(.system(size: 20, weight: .bold))
                .frame(width: Self.size.width, height: Self.size.height)
                .foregroundStyle(.white)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    }
    
    var timerText: Text? {
        if store.isComplete {
            Text("終わり")
        } else if let time = store.time {
            Text(timerInterval: time.startDate...time.endDate, countsDown: true)
        } else {
            nil
        }
    }
    
    var backgroundColor: Color {
        if store.isComplete {
            return .orange
        }
        return .gray
    }
}
