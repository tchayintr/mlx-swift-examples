//
//  GlassNewChatButton.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Floating action button for creating a new chat with futuristic glass morphism design
struct GlassNewChatButton: View {
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.6
    
    var body: some View {
        Button(action: {
            // Cross-platform haptic feedback for premium feel
            performHapticFeedback(style: .medium)
            
            withAnimation(.glassBounce) {
                action()
            }
        }) {
            ZStack {
                // Animated glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.blue.opacity(glowOpacity), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .scaleEffect(pulseScale)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseScale)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowOpacity)
                
                // Main button
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .glassFAB()
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .rotationEffect(.degrees(isPressed ? 90 : 0))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onPressGesture(
            pressing: { pressing in
                withAnimation(.glassEaseInOut) {
                    isPressed = pressing
                }
            },
            perform: {}
        )
        .onAppear {
            pulseScale = 1.2
            glowOpacity = 0.3
        }
    }
}

/// Custom press gesture for better control over button interactions
extension View {
    func onPressGesture(pressing: @escaping (Bool) -> Void, perform: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    pressing(true)
                }
                .onEnded { _ in
                    pressing(false)
                    perform()
                }
        )
    }
}

#Preview {
    ZStack {
        // Dark background to show glass effect
        Color.black.ignoresSafeArea()
        
        GlassNewChatButton {
            print("New chat tapped")
        }
    }
}