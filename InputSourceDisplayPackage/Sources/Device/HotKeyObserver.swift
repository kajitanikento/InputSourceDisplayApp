//
//  HotKeyObserver.swift
//  InputSourceDisplayPackage
//
//  Created by kajitani kento on 2025/12/19.
//

import Carbon.HIToolbox
import Cocoa
import ComposableArchitecture

final actor HotKeyObserver: Sendable {
    static let shared = HotKeyObserver()
    
    private var hotKeyRefs: [HotKey: EventHotKeyRef] = [:]
    private var continuation: AsyncStream<HotKey>.Continuation?
    
    init() {
        Task {
            await registerHotKeys()
        }
    }
    
    var stream: AsyncStream<HotKey> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    func stop() {
        continuation?.finish()
        continuation = nil
    }
    
    private func onHotKeyPressed(id: UInt32) {
        guard let hotKey = HotKey(rawValue: id) else {
            return
        }
        continuation?.yield(hotKey)
    }
    
    private func registerHotKeys() {
        registerHotKey(
            keyCode: UInt32(kVK_ANSI_K),
            modifiers: UInt32(cmdKey),
            hotKey: .callCat
        )
        registerHotKey(
            keyCode: UInt32(kVK_ANSI_U),
            modifiers: UInt32(cmdKey),
            hotKey: .toggleHidden
        )
    }
    
    private func registerHotKey(
        keyCode: UInt32,
        modifiers: UInt32,
        hotKey: HotKey
    ) {
        
        var hotKeyID = EventHotKeyID(
            signature: OSType(UInt32(truncatingIfNeeded: hotKey.fourCC)),
            id: hotKey.rawValue
        )
        var hotKeyRef = hotKeyRefs[hotKey]
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        hotKeyRefs[hotKey] = hotKeyRef
        
        guard status == noErr else {
            print("RegisterEventHotKey failed:", status)
            return
        }
        
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        InstallEventHandler(
            GetApplicationEventTarget(),
            {  _, eventRef, _ in
                var hkID = EventHotKeyID()
                GetEventParameter(
                    eventRef,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hkID
                )
                
                HotKeyObserver.shared.onHotKeyPressed(id: hkID.id)
                return noErr
            },
            1,
            &eventType,
            nil,
            nil
        )
    }
}

enum HotKey: UInt32 {
    case callCat = 1
    case toggleHidden = 2
    
    private var stringValue: String {
        switch self {
        case .callCat: "CallCat"
        case .toggleHidden: "ToggleHidden"
        }
    }
    
    var fourCC: UInt32 {
        var result: UInt32 = 0
        for u in self.stringValue.utf8.prefix(4) { result = (result << 8) + UInt32(u) }
        return result
    }
}

// MARK: define swift dependency

extension DependencyValues {
    var hotKeyObserver: HotKeyObserver {
        get { self[HotKeyObserverKey.self] }
        set { self[HotKeyObserverKey.self] = newValue }
    }
}

private enum HotKeyObserverKey: DependencyKey, Sendable {
    
    static let liveValue: HotKeyObserver = .shared
    
}
