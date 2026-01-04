//
//  ParticleDisappearEffect.swift
//  CharmingPanel
//
//  Created by Claude Code
//

import SwiftUI

/// パーティクルとして消えていくエフェクトを表示するView
struct ParticleDisappearEffect: View {
    let particleCount: Int
    let duration: Double
    let onComplete: () -> Void

    @State private var particles: [Particle] = []
    @State private var isAnimating = false

    init(
        particleCount: Int = 80,
        duration: Double = 1.2,
        onComplete: @escaping () -> Void = {}
    ) {
        self.particleCount = particleCount
        self.duration = duration
        self.onComplete = onComplete
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .offset(
                            x: isAnimating ? particle.endX : particle.startX,
                            y: isAnimating ? particle.endY : particle.startY
                        )
                        .opacity(isAnimating ? 0 : particle.initialOpacity)
                        .rotationEffect(.degrees(isAnimating ? particle.rotation : 0))
                        .animation(
                            .easeIn(duration: duration * particle.speedMultiplier),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
                startAnimation()
            }
        }
    }

    private func generateParticles(in size: CGSize) {
        let gridSize = Int(sqrt(Double(particleCount)))
        let cellWidth = size.width / CGFloat(gridSize)
        let cellHeight = size.height / CGFloat(gridSize)

        var newParticles: [Particle] = []

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let x = CGFloat(col) * cellWidth + cellWidth / 2 - size.width / 2
                let y = CGFloat(row) * cellHeight + cellHeight / 2 - size.height / 2

                let particle = Particle(
                    startX: x,
                    startY: y,
                    endX: x + CGFloat.random(in: -100...100),
                    endY: y + CGFloat.random(in: 50...300),
                    size: CGFloat.random(in: 2...6),
                    color: randomColor(),
                    rotation: Double.random(in: -360...360),
                    speedMultiplier: Double.random(in: 0.8...1.2),
                    initialOpacity: Double.random(in: 0.6...1.0)
                )
                newParticles.append(particle)
            }
        }

        particles = newParticles
    }

    private func startAnimation() {
        withAnimation {
            isAnimating = true
        }

        // アニメーション完了後にコールバックを実行
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            onComplete()
        }
    }

    private func randomColor() -> Color {
        let colors: [Color] = [
            .white,
            .gray,
            Color(red: 0.9, green: 0.9, blue: 0.9),
            Color(red: 0.8, green: 0.8, blue: 0.8)
        ]
        return colors.randomElement() ?? .white
    }
}

struct Particle: Identifiable {
    let id = UUID()
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let size: CGFloat
    let color: Color
    let rotation: Double
    let speedMultiplier: Double
    let initialOpacity: Double
}

#Preview {
    ZStack {
        Color.black
        ParticleDisappearEffect()
            .frame(width: 120, height: 170)
    }
}
