//
//  ActorPanel.swift
//  InputSourceDisplayApp
//
//  Created by kajitani kento on 2025/12/14.
//

import ComposableArchitecture

@Reducer
struct ActorPanel {
    
    @ObservableState
    struct State {
        var currentInputSource: InputSource = .abc        
        var isHide: Bool = false
        var withAnimation: Bool = true
        var withMove: Bool = true
    }
    
    enum Action {
        // Lifecycle
        case onAppear
        case onDisappear
        
        // View inputs
        case toggleHidden(to: Bool? = nil)
        case toggleWithAnimation
        case toggleWithMove
        
        // Dependency inputs
        case changeInputSource(InputSource)
    }
    
    @Dependency(\.inputSource) var inputSource
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await newSouce in await self.inputSource.stream {
                        await send(.changeInputSource(newSouce))
                    }
                }
                
            case .onDisappear:
                inputSource.stop()
                return .none
                
            case let .toggleHidden(isHide):
                if let isHide {
                    state.isHide = isHide
                } else {
                    state.isHide.toggle()
                }
                return .none
            
            case .toggleWithAnimation:
                state.withAnimation.toggle()
                return .none
                
            case .toggleWithMove:
                state.withMove.toggle()
                return .none
                
            case let .changeInputSource(source):
                state.currentInputSource = source
                return .none
            }
        }
    }
}


