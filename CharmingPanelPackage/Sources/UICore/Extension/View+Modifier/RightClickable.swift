//
//  RightClickable.swift
//  CharmingPanelPackage
//
//  Created by kajitani kento on 2025/12/20.
//

import SwiftUI

extension View {
    
    func onRightClick(perform action: @escaping () -> Void) -> some View {
        self.overlay(
            RightClickableView(onClick: action)
        )
    }
    
}

private struct RightClickableView: NSViewRepresentable {
    var onClick: () -> Void
    
    func makeNSView(context: Context) -> some NSView {
        RightClickableNSView(onClick: onClick)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}

private final class RightClickableNSView: NSView {
    var onClick: () -> Void
    
    init(onClick: @escaping () -> Void) {
        self.onClick = onClick
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightMouseDown(with event: NSEvent) {
        onClick()
    }
}
