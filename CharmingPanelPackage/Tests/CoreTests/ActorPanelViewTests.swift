//
//  ActorPanelViewTests.swift
//  CoreTests
//
//  Created by Claude on 2026/01/04.
//

import XCTest
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Core

@MainActor
final class ActorPanelViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // スナップショットテストのデバイス設定を統一
        // isRecording = true // 初回実行時や基準画像を更新したい場合はコメント解除
    }

    // MARK: - 基本的なビューテスト

    func testActorPanelView_withDefaultState() {
        let store = Store(initialState: ActorPanel.State()) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.abc)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withHiraganaInputSource() {
        let store = Store(initialState: ActorPanel.State(currentInputSource: .hiragana)) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.hiragana)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withKatakanaInputSource() {
        let store = Store(initialState: ActorPanel.State(currentInputSource: .katakana)) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.katakana)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withKoreanInputSource() {
        let store = Store(initialState: ActorPanel.State(currentInputSource: .korean)) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.korean)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withChineseSimplifiedInputSource() {
        let store = Store(initialState: ActorPanel.State(currentInputSource: .chineseSimplified)) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.chineseSimplified)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    // MARK: - 猫のタイプ別テスト

    func testActorPanelView_withThinkCatType() {
        var state = ActorPanel.State()
        state.cat.type = .think
        state.isShowMenu = true

        let store = Store(initialState: state) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.abc)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withPickUpCatType() {
        var state = ActorPanel.State()
        state.cat.type = .pickUp
        state.isLongPress = true

        let store = Store(initialState: state) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.abc)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withHasTimerCatType() {
        var state = ActorPanel.State()
        state.cat.type = .hasTimer
        state.pomodoroTimer.isTimerRunning = true
        state.pomodoroTimer.currentTime = 1500 // 25分

        let store = Store(initialState: state) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.abc)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    func testActorPanelView_withCompleteTimerCatType() {
        var state = ActorPanel.State()
        state.cat.type = .completeTimer
        state.pomodoroTimer.isComplete = true
        state.pomodoroTimer.currentTime = 0

        let store = Store(initialState: state) {
            ActorPanel()
        } withDependencies: {
            $0.inputSource.stream = { .init { continuation in
                continuation.yield(.abc)
            } }
        }

        let view = ActorPanelView(store: store)
            .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 120, height: 170)))
    }

    // MARK: - 複数言語の入力ソーステスト

    func testActorPanelView_withVariousEuropeanInputSources() {
        let inputSources: [InputSource] = [.french, .german, .spanish, .italian, .russian]

        for inputSource in inputSources {
            let store = Store(initialState: ActorPanel.State(currentInputSource: inputSource)) {
                ActorPanel()
            } withDependencies: {
                $0.inputSource.stream = { .init { continuation in
                    continuation.yield(inputSource)
                } }
            }

            let view = ActorPanelView(store: store)
                .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 120, height: 170)),
                named: "with\(String(describing: inputSource).capitalized)"
            )
        }
    }

    func testActorPanelView_withVariousAsianInputSources() {
        let inputSources: [InputSource] = [.thai, .vietnamese, .arabic, .hebrew]

        for inputSource in inputSources {
            let store = Store(initialState: ActorPanel.State(currentInputSource: inputSource)) {
                ActorPanel()
            } withDependencies: {
                $0.inputSource.stream = { .init { continuation in
                    continuation.yield(inputSource)
                } }
            }

            let view = ActorPanelView(store: store)
                .frame(width: ActorPanelView.size.width, height: ActorPanelView.size.height)

            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 120, height: 170)),
                named: "with\(String(describing: inputSource).capitalized)"
            )
        }
    }
}
