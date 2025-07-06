//
//  GlassDesignSystem.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Design system for futuristic glass morphism UI components
struct GlassDesignSystem {
    
    // MARK: - Colors
    struct Colors {
        static let primaryGlass = Color.white.opacity(0.1)
        static let secondaryGlass = Color.white.opacity(0.05)
        static let accentGlass = Color.blue.opacity(0.2)
        static let userBubbleGlass = LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let assistantBubbleGlass = LinearGradient(
            colors: [Color.white.opacity(0.1), Color.gray.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let glowBlue = Color.blue.opacity(0.6)
        static let glowCyan = Color.cyan.opacity(0.4)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
}

// MARK: - Glass Modifiers
extension View {
    
    /// Applies primary glass morphism effect
    func glassPrimary() -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    /// Applies secondary glass morphism effect
    func glassSecondary() -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                    .stroke(Color.white.opacity(0.15), lineWidth: 0.3)
            )
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
    
    /// Applies user message glass bubble effect
    func glassUserBubble() -> some View {
        self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                        .fill(GlassDesignSystem.Colors.userBubbleGlass)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: .blue.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    /// Applies assistant message glass bubble effect
    func glassAssistantBubble() -> some View {
        self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                        .fill(.regularMaterial)
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                        .fill(GlassDesignSystem.Colors.assistantBubbleGlass)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.3)
            )
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    /// Applies floating action button glass effect with glow
    func glassFAB() -> some View {
        self
            .background(
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.blue.opacity(0.4), Color.cyan.opacity(0.2)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 30
                            )
                        )
                }
            )
            .overlay(
                Circle()
                    .stroke(Color.blue.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
            .shadow(color: .blue.opacity(0.6), radius: 4, x: 0, y: 2)
    }
    
    /// Applies glass input field effect
    func glassInputField() -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
    }
    
    /// Applies subtle glass card effect for info displays
    func glassInfoCard() -> some View {
        self
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.small)
                    .stroke(Color.white.opacity(0.15), lineWidth: 0.3)
            )
    }
}

// MARK: - Animation Presets
extension Animation {
    static let glassSpring = Animation.spring(
        response: 0.4,
        dampingFraction: 0.8,
        blendDuration: 0.2
    )
    
    static let glassEaseInOut = Animation.easeInOut(duration: 0.3)
    
    static let glassBounce = Animation.spring(
        response: 0.3,
        dampingFraction: 0.6,
        blendDuration: 0.1
    )
}

// MARK: - Typography Extensions
extension Font {
    static let glassChatText = Font.system(size: 16, weight: .regular, design: .rounded)
    static let glassTitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let glassCaption = Font.system(size: 12, weight: .medium, design: .rounded)
    static let glassButton = Font.system(size: 14, weight: .medium, design: .rounded)
}

// MARK: - Cross-Platform Haptic Feedback
enum HapticFeedbackStyle {
    case light, medium, heavy
    
    #if canImport(UIKit)
    var uiKitStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium  
        case .heavy: return .heavy
        }
    }
    #endif
}

/// Cross-platform haptic feedback helper
func performHapticFeedback(style: HapticFeedbackStyle = .medium) {
    #if canImport(UIKit)
    let generator = UIImpactFeedbackGenerator(style: style.uiKitStyle)
    generator.impactOccurred()
    #endif
    // macOS: Silent fallback (no haptic feedback available)
}

// MARK: - Cross-Platform Navigation & Presentation
extension View {
    /// Applies platform-appropriate navigation styling for glass morphism
    func glassNavigation() -> some View {
        #if os(iOS)
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        #else
        self
            // macOS: Use default navigation styling
        #endif
    }
    
    /// Cross-platform sheet presentation with glass morphism styling
    func glassSheet() -> some View {
        #if os(iOS)
        self
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        #else
        self
            // macOS: Standard sheet presentation
        #endif
    }
    
    /// Cross-platform toolbar with trailing placement for glass UI
    func glassToolbar<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        #if os(iOS)
        self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                content()
            }
        }
        #else
        self.toolbar {
            ToolbarItem(placement: .automatic) {
                content()
            }
        }
        #endif
    }
}