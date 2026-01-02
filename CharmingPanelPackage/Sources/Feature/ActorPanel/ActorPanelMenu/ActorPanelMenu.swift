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
        // View inputs
        case onClickStartTimer(time: PomodoroTimer.PomodoroTime)
        case onClickStopTimer
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onClickStartTimer(let time):
                state.startedTimerTime = time
                return .none
                
            case .onClickStopTimer:
                state.startedTimerTime = nil
                return .none
            }
        }
    }
}
