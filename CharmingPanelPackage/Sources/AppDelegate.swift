//
//  AppDelegate.swift
//  CharmingPanel
//
//  Created by kajitani kento on 2025/12/06.
//

import AppKit
import ComposableArchitecture

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    let store = Store(initialState: ActorPanel.State()) {
        ActorPanel()
        #if DEBUG
            // ._printChanges()
        #endif
    }

    private var statusItem: NSStatusItem!
    private var toggleHiddenMenuItem: NSMenuItem!
    
    private var panelController: ActorPanelController!

    public override init() {
        super.init()
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        panelController = ActorPanelController(store: store)
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        let bar = NSStatusBar.system
        statusItem = bar.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "keyboard",
                accessibilityDescription: "Input Source Indicator"
            )
            button.action = #selector(togglePanel)
            button.target = self
        }
        
        let menu = NSMenu()
        toggleHiddenMenuItem = NSMenuItem(title: "", action: #selector(togglePanel), keyEquivalent: "u")
        updateToggleHiddenMenuItemTitle()
        menu.addItem(toggleHiddenMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    private func updateToggleHiddenMenuItemTitle() {
        toggleHiddenMenuItem.title = "\(store.isHide ? "Show" : "Hide") panel"
    }
    
    @objc private func togglePanel() {
        store.send(.toggleHidden())
        updateToggleHiddenMenuItemTitle()
    }
    
    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
