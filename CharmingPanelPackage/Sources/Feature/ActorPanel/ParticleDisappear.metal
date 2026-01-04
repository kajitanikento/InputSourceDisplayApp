//
//  ParticleDisappear.metal
//  CharmingPanel
//
//  Created by Claude Code
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// シェーダー用のパラメータ
// progress: 0.0〜1.0のアニメーション進行度
// randomSeed: ランダム性を生成するためのシード値

// ランダム値を生成する関数
float random(float2 st, float seed) {
    return fract(sin(dot(st.xy + seed, float2(12.9898, 78.233))) * 43758.5453123);
}

// パーティクル消失エフェクト
[[ stitchable ]] half4 particleDisappear(
    float2 position,
    SwiftUI::Layer layer,
    float progress,
    float randomSeed
) {
    // 元の色を取得
    half4 color = layer.sample(position);

    // 完全に透明な場合は早期リターン
    if (color.a < 0.01) {
        return color;
    }

    // このピクセルのランダム値を生成（位置ベース）
    float2 pixelUV = position;
    float randomValue = random(pixelUV, randomSeed);
    float randomValue2 = random(pixelUV, randomSeed + 1.0);

    // パーティクルの速度（ランダム性を持たせる）
    float speedMultiplier = 0.8 + randomValue * 0.4; // 0.8〜1.2
    float currentProgress = min(progress * speedMultiplier, 1.0);

    // 横方向のランダムな移動（-50〜50ピクセル）
    float xOffset = (randomValue - 0.5) * 100.0 * currentProgress;

    // 下方向への移動（50〜300ピクセル、重力的な加速）
    float yOffset = (50.0 + randomValue2 * 250.0) * currentProgress * currentProgress;

    // 新しいサンプリング位置
    float2 newPosition = position - float2(xOffset, yOffset);

    // 新しい位置でサンプリング
    half4 newColor = layer.sample(newPosition);

    // フェードアウト（進行度に応じて透明度を下げる）
    float fadeOut = 1.0 - currentProgress;
    newColor.a *= half(fadeOut);

    // ピクセルをやや小さくする効果（パーティクル感を出す）
    float pixelSize = 1.0 - currentProgress * 0.3;
    float2 offset = fract(position);
    float dist = length(offset - 0.5);
    if (dist > pixelSize * 0.5) {
        newColor.a *= half(max(0.0, 1.0 - (dist - pixelSize * 0.5) * 4.0));
    }

    return newColor;
}
