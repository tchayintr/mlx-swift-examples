//
//  CompactNewChatButton.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Enhanced new chat button with futuristic design for toolbar integration
struct CompactNewChatButton: View {
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovering = false
    
    var body: some View {
        Button(action: {
            performHapticFeedback(style: .medium)
            withAnimation(.glassBounce) {
                action()
            }
        }) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
            .padding(.horizontal, GlassDesignSystem.Spacing.small)
            .padding(.vertical, GlassDesignSystem.Spacing.xs)
            .glassPrimary()
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.glassEaseInOut, value: isPressed)
            #if os(macOS)
            .onHover { hovering in
                isHovering = hovering
            }
            #endif
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.glassEaseInOut) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    HStack {
        CompactNewChatButton {
            print("New chat tapped")
        }
    }
    .padding()
}