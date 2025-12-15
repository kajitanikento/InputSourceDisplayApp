//
//  PomodoroTimerView.swift
//  InputSourceDisplayApp
//
//  Created by kajitani kento on 2025/12/14.
//

import SwiftUI
import ComposableArchitecture

struct PomodoroTimerView: View {
    
    @Bindable var store: StoreOf<PomodoroTimer>
    
    var body: some View {
        if let timerText {
            timerText
                .font(.system(size: 20, weight: .bold))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundStyle(.white)
                .background(.gray)
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
}
