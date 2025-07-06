//
//  GenerationInfoView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Info button that shows generation throughput in a popover when tapped
struct GenerationInfoView: View {
    let tokensPerSecond: Double
    
    @State private var showingInfo = false
    @State private var isPulsing = false
    
    // Performance-based color coding
    private var performanceColor: Color {
        if tokensPerSecond > 50 {
            return .green // High performance
        } else if tokensPerSecond > 20 {
            return .blue  // Normal performance
        } else {
            return .orange // Low performance
        }
    }
    
    // Performance level text
    private var performanceLevel: String {
        if tokensPerSecond > 50 {
            return "High Performance"
        } else if tokensPerSecond > 20 {
            return "Normal Performance"
        } else {
            return "Low Performance"
        }
    }

    var body: some View {
        // Only show when there's throughput data available
        if tokensPerSecond > 0 {
            Button(action: {
                showingInfo.toggle()
                performHapticFeedback(style: .light)
            }) {
                Image(systemName: "waveform.path")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(performanceColor)
                    .frame(width: 32, height: 32)
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            }
            .padding(.horizontal, GlassDesignSystem.Spacing.small)
            .padding(.vertical, GlassDesignSystem.Spacing.xs)
            .glassPrimary()
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                isPulsing = true
            }
            .onChange(of: tokensPerSecond) { _, _ in
                withAnimation(.glassEaseInOut) {
                    isPulsing = tokensPerSecond > 0
                }
            }
            .popover(isPresented: $showingInfo) {
                VStack(spacing: GlassDesignSystem.Spacing.small) {
                    // Header with futuristic icon
                    HStack(spacing: GlassDesignSystem.Spacing.xs) {
                        Image(systemName: "waveform.path")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(performanceColor)
                        
                        Text("Speed")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    
                    // Performance indicator with gradient background
                    VStack(spacing: 2) {
                        Text("\(tokensPerSecond, format: .number.precision(.fractionLength(1)))")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(performanceColor)
                        
                        Text("tokens/sec")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, GlassDesignSystem.Spacing.xs)
                    .padding(.horizontal, GlassDesignSystem.Spacing.small)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(performanceColor.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(performanceColor.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    // Performance level indicator
                    HStack(spacing: GlassDesignSystem.Spacing.xs) {
                        Circle()
                            .fill(performanceColor)
                            .frame(width: 6, height: 6)
                        
                        Text(performanceLevel)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(GlassDesignSystem.Spacing.medium)
                .frame(width: 140)
                .glassPrimary()
                .presentationCompactAdaptation(.popover)
            }
        }
    }
}

#Preview {
    GenerationInfoView(tokensPerSecond: 58.5834)
}
