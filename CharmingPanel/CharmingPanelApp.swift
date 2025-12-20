//
//  CharmingPanel.swift
//  CharmingPanel
//
//  Created by kajitani kento on 2025/11/29.
//

import SwiftUI
import CharmingPanelPackage

@main
struct CharmingPanel: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            VStack(alignment: .leading, spacing: 8) {
                Text("Input Source Indicator")
                    .font(.headline)
                Text("メニューバーのキーボードアイコンから表示を切り替えられます。")
                    .font(.caption)
            }
            .padding()
            .frame(width: 300)
        }
    }
}
