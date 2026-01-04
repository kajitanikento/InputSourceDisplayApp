//
//  ParticleDisappearEffect.swift
//  CharmingPanel
//
//  Created by Claude Code
//

import SwiftUI

/// Metalシェーダーを使用してパーティクルとして消えていくエフェクトを表示するView
struct ParticleDisappearEffect<Content: View>: View {
    let content: Content
    let duration: Double
    let onComplete: () -> Void

    @State private var progress: Double = 0
    @State private var randomSeed: Double = 0

    init(
        duration: Double = 1.2,
        onComplete: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.duration = duration
        self.onComplete = onComplete
        self.content = content()
    }

    var body: some View {
        content
            .layerEffect(
                ShaderLibrary.particleDisappear(
                    .float(progress),
                    .float(randomSeed)
                ),
                maxSampleOffset: .zero
            )
            .onAppear {
                // ランダムシードを生成
                randomSeed = Double.random(in: 0...1000)

                // アニメーション開始
                withAnimation(.easeIn(duration: duration)) {
                    progress = 1.0
                }

                // アニメーション完了後にコールバックを実行
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    onComplete()
                }
            }
    }
}

#Preview {
    ZStack {
        Color.black
        ParticleDisappearEffect {
            Image(systemName: "star.fill")
                .resizable()
                .foregroundStyle(.yellow)
                .frame(width: 100, height: 100)
        }
    }
}
