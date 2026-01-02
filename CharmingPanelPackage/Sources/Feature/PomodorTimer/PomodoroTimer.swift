//
//  PomodoroTimer.swift
//  CharmingPanel
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
        
        var isShow: Bool {
            isTimerRunning || isComplete
        }
    }
    
    enum Action {
        case startTimer(time: PomodoroTime)
        case completeTimer
        case stopTimer
    }
    
    @Dependency(\.continuousClock) var clock
    
    enum CancelID: String {
        case timer
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .startTimer(time):
                state.time = time
                state.isComplete = false
                return .run { send in
                    try await self.clock.sleep(for: .seconds(time.endDate.timeIntervalSince(time.startDate)))
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
        var intervalMinute: Int
        
        var timeInterval: ClosedRange<Date> {
            startDate...endDate
        }
        
        init(
            startDate: Date,
            intervalMinute: Int,
        ) {
            self.startDate = startDate
            endDate = startDate.addingTimeInterval(Double(intervalMinute * 60))
            self.intervalMinute = intervalMinute
        }
    }
}
