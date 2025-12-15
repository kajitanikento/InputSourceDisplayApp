//
//  PomodoroTimer.swift
//  InputSourceDisplayApp
//
//  Created by kajitani kento on 2025/12/14.
//

import ComposableArchitecture
import Foundation

@Reducer
struct PomodoroTimer {
    
    @ObservableState
    struct State {
        var time: PomodoroTime?
        var isComplete: Bool = false
        
        var isTimerRunning: Bool {
            time != nil
        }
    }
    
    enum Action {
        case startTimer(endDate: Date)
        case completeTimer
        case stopTimer
    }
    
    @Dependency(\.date) var date
    @Dependency(\.continuousClock) var clock
    
    enum CancelID: String {
        case timer
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .startTimer(endDate):
                let startDate = date.now
                state.time = .init(
                    startDate: startDate,
                    endDate: endDate
                )
                state.isComplete = false
                return .run { send in
                    try await self.clock.sleep(for: .seconds(endDate.timeIntervalSince(startDate)))
                    await send(.completeTimer)
                }
                .cancellable(id: CancelID.timer)
                
            case .completeTimer:
                state.isComplete = true
                return .none
                
            case .stopTimer:
                state.isComplete = false
                state.time = nil
                return .cancel(id: CancelID.timer)
                
            }
        }
    }
}

extension PomodoroTimer {
    struct PomodoroTime {
        var startDate: Date
        var endDate: Date
    }
}
