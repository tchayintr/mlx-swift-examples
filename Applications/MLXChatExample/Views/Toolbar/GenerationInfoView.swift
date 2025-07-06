//
//  GenerationInfoView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Display-only glass indicator for generation throughput
struct GenerationInfoView: View {
    let tokensPerSecond: Double
    
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: GlassDesignSystem.Spacing.xs) {
            // Performance indicator icon
            Image(systemName: "speedometer")
                .font(.glassCaption)
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
            
            // Throughput text
            Text("\(tokensPerSecond, format: .number.precision(.fractionLength(1))) tok/s")
                .font(.glassCaption)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, GlassDesignSystem.Spacing.small)
        .padding(.vertical, GlassDesignSystem.Spacing.xs)
        .glassInfoCard()
        .opacity(tokensPerSecond > 0 ? 1.0 : 0.5)
        .onAppear {
            if tokensPerSecond > 0 {
                isAnimating = true
            }
        }
        .onChange(of: tokensPerSecond) { _, newValue in
            withAnimation(.glassEaseInOut) {
                isAnimating = newValue > 0
            }
        }
    }
}

#Preview {
    GenerationInfoView(tokensPerSecond: 58.5834)
}
