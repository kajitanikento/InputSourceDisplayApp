//
//  ActorPanelMenu.swift
//  CharmingPanelPackage
//
//  Created by kajitani kento on 2025/12/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ActorPanelMenu {
    
    @ObservableState
    struct State {
        var startedTimerTime: PomodoroTimer.PomodoroTime?
    }
    
    enum Action {
        case onStartTimer(time: PomodoroTimer.PomodoroTime)
        case onStopTimer
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onStartTimer(let time):
                state.startedTimerTime = time
                return .none
                
            case .onStopTimer:
                state.startedTimerTime = nil
                return .none
            }
        }
    }
}
