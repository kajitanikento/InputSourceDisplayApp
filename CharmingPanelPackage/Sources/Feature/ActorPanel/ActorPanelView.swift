//
//  ActorPanelView.swift
//  CharmingPanel
//
//  Created by kajitani kento on 2025/12/06.
//

import SwiftUI
import ComposableArchitecture

struct ActorPanelView: View {
    nonisolated static let size = CGSize(width: 120, height: 170)
    
    @Bindable var store: StoreOf<ActorPanel>

    @State var hoverAnimationProgress: Double = 0
    
    var body: some View {
        content
            .onAppear {
                store.send(.onAppear)
            }
            .onDisappear {
                store.send(.onDisappear)
            }
    }
    
    private var content: some View {
        actorContent
    }
    
    // MARK: Subviews
    
    private var actorContent: some View {
        ZStack {
            if isShowInputSourceLabel {
                inputSourceLabel
            }
            cat
            if isShowTimerLabel {
                pomodoroTimer
            }
        }
        .onRightClick {
            store.send(.onRightClickActor)
        }
        .onLongPressGesture(
            minimumDuration: 1,
            perform: { /** no operations */ },
            onPressingChanged: { isPress in
                store.send(.onLongPressActor(isPress))
            }
        )
        .onEndWindowDrag(disable: !canMovePanel) {
            store.send(.onEndWindowDrag)
        }
        .onHover { isHover in
            store.send(.onHoverActor(isHover))
        }
    }
    
    private var pomodoroTimer: some View {
        PomodoroTimerView(
            store: store.scope(state: \.pomodoroTimer, action: \.pomodoroTimer)
        )
        .offset(y: -20)
    }
    
    private var cat: some View {
        CatView(
            store: store.scope(state: \.cat, action: \.cat)
        )
        .frame(width: Self.size.width - 12, height: Self.size.height - 12)
        .shadow(color: .black.opacity(0.2),radius: 4, x: 2, y: 2)
    }
    
    private var inputSourceLabel: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            
            _inputSourceLabel
                .padding(.bottom, 12)
                .padding(.trailing, 4)
        }
        .frame(height: Self.size.height)
        .shadow(color: .black.opacity(0.2),radius: 4, x: 2, y: 2)
    }
    
    private var _inputSourceLabel: some View {
        VStack {
            Text(shortLabel)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .frame(width: 44, height: 44)
        .background(backgroundColor)
        .clipShape(Circle())
    }
    
    // MARK: Helpers

    private var shortLabel: String {
        switch store.currentInputSource {
        // 英数字・ラテン文字系
        case .abc: "A"
        case .french: "F"
        case .german: "D"
        case .spanish: "E"
        case .portuguese: "P"
        case .italian: "I"
        case .dutch: "N"
        case .swedish: "S"
        case .norwegian: "N"
        case .danish: "D"
        case .finnish: "F"
        case .polish: "P"
        case .czech: "Č"
        case .hungarian: "M"
        case .turkish: "T"

        // 日本語
        case .hiragana: "あ"
        case .katakana: "ア"

        // アジア言語
        case .korean: "한"
        case .chineseSimplified: "简"
        case .chineseTraditional: "繁"
        case .thai: "ท"
        case .vietnamese: "V"

        // 中東・その他
        case .arabic: "ع"
        case .hebrew: "ע"

        // ヨーロッパ・その他
        case .russian: "Я"
        case .greek: "Ω"

        // 不明
        case .unknown: "?"
        }
    }

    private var textColor: Color {
        switch store.currentInputSource {
        default: .white
        }
    }

    private var backgroundColor: Color {
        switch store.currentInputSource {
        // 英数字・ラテン文字系（青系）
        case .abc: .blue
        case .french: Color(red: 0.0, green: 0.3, blue: 0.6)
        case .german: Color(red: 0.1, green: 0.4, blue: 0.7)
        case .spanish: Color(red: 0.8, green: 0.4, blue: 0.0)
        case .portuguese: Color(red: 0.0, green: 0.5, blue: 0.3)
        case .italian: Color(red: 0.0, green: 0.6, blue: 0.4)
        case .dutch: Color(red: 0.9, green: 0.5, blue: 0.0)
        case .swedish: Color(red: 0.0, green: 0.4, blue: 0.7)
        case .norwegian: Color(red: 0.0, green: 0.3, blue: 0.6)
        case .danish: Color(red: 0.8, green: 0.1, blue: 0.2)
        case .finnish: Color(red: 0.0, green: 0.5, blue: 0.8)
        case .polish: Color(red: 0.8, green: 0.1, blue: 0.3)
        case .czech: Color(red: 0.0, green: 0.4, blue: 0.7)
        case .hungarian: Color(red: 0.3, green: 0.7, blue: 0.3)
        case .turkish: Color(red: 0.8, green: 0.0, blue: 0.2)

        // 日本語（赤系）
        case .hiragana: .red
        case .katakana: Color(red: 0.9, green: 0.2, blue: 0.3)

        // アジア言語（緑〜紫系）
        case .korean: Color(red: 0.5, green: 0.0, blue: 0.8)
        case .chineseSimplified: Color(red: 0.8, green: 0.0, blue: 0.0)
        case .chineseTraditional: Color(red: 0.6, green: 0.0, blue: 0.6)
        case .thai: Color(red: 0.2, green: 0.6, blue: 0.8)
        case .vietnamese: Color(red: 0.8, green: 0.6, blue: 0.0)

        // 中東・その他（オレンジ〜茶系）
        case .arabic: Color(red: 0.0, green: 0.6, blue: 0.4)
        case .hebrew: Color(red: 0.0, green: 0.5, blue: 0.7)

        // ヨーロッパ・その他
        case .russian: Color(red: 0.0, green: 0.4, blue: 0.8)
        case .greek: Color(red: 0.2, green: 0.5, blue: 0.9)

        // 不明（グレー）
        case .unknown: .gray
        }
    }
    
    private var canMovePanel: Bool {
        store.canMovePanel
    }
    
    private var isShowInputSourceLabel: Bool {
        store.cat.type.shouldShowInputSource
    }
    
    private var isShowTimerLabel: Bool {
        store.cat.type.shouldShowTimer
    }
}

extension ActorPanel.State {
    var canMovePanel: Bool {
        if isShowMenu {
            return isHoverActor
        }
        return true
    }
}

extension CatType {
    var shouldShowInputSource: Bool {
        self != .pickUp
    }
    
    var shouldShowTimer: Bool {
        switch self {
        case .pickUp, .think: false
        default: true
        }
    }
}

#Preview {
    ActorPanelView(
        store: .init(
            initialState: {
                var state = ActorPanel.State()
                state.cat.type = .onBall
                state.isShowMenu = true
                return state
            }()
        ) {
            withDependencies {
                $0.inputSource.stream = { .init { continuation in
                    continuation.yield(.hiragana)
                } }
            } operation: {
                ActorPanel()
            }
        }
    )
}
