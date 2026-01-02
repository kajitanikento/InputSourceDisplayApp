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
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            let image = NSImage(resource: .init(name: "MenuIcon", bundle: .module))
            image.size = .init(width: 20, height: 20)
            button.image = image
            button.action = #selector(togglePanel)
            button.target = self
        }
        
        let menu = NSMenu()
        toggleHiddenMenuItem = NSMenuItem(title: "", action: #selector(togglePanel), keyEquivalent: "u")
        toggleHiddenMenuItem.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "Switch panel visibility")
        updateToggleHiddenMenuItemTitle()
        menu.addItem(toggleHiddenMenuItem)
        menu.addItem(NSMenuItem.separator())
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitMenuItem.image = NSImage(systemSymbolName: "xmark.circle.fill", accessibilityDescription: "Quit application")
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
    }
    
    private func updateToggleHiddenMenuItemTitle() {
        toggleHiddenMenuItem.title = "\(store.isPanelHidden ? "Show" : "Hide") panel"
    }
    
    @objc private func togglePanel() {
        store.send(.onClickTogglePanelHidden())
        updateToggleHiddenMenuItemTitle()
    }
    
    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
