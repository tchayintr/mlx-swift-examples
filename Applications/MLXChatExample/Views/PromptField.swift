//
//  PromptField.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Futuristic input field with glass morphism design and enhanced interactions
struct PromptField: View {
    @Binding var prompt: String
    @State private var task: Task<Void, Never>?
    @FocusState private var isTextFieldFocused: Bool
    @State private var sendButtonPressed = false
    @State private var mediaButtonPressed = false

    let sendButtonAction: () async -> Void
    let mediaButtonAction: (() -> Void)?

    var body: some View {
        HStack(spacing: GlassDesignSystem.Spacing.medium) {
            // Media attachment button (if available)
            if let mediaButtonAction {
                Button(action: {
                    performHapticFeedback(style: .light)
                    mediaButtonAction()
                }) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .glassPrimary()
                        .scaleEffect(mediaButtonPressed ? 0.9 : 1.0)
                        .animation(.glassBounce, value: mediaButtonPressed)
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.glassEaseInOut) {
                        mediaButtonPressed = pressing
                    }
                }, perform: {})
            }

            // Glass input field
            ZStack(alignment: .leading) {
                // Placeholder
                if prompt.isEmpty && !isTextFieldFocused {
                    Text("Type your message...")
                        .font(.glassChatText)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, GlassDesignSystem.Spacing.large)
                }
                
                TextField("", text: $prompt, axis: .vertical)
                    .font(.glassChatText)
                    .foregroundColor(.primary)
                    .padding(.horizontal, GlassDesignSystem.Spacing.large)
                    .padding(.vertical, GlassDesignSystem.Spacing.medium)
                    .textFieldStyle(PlainTextFieldStyle())
                    .lineLimit(1...6)
                    .focused($isTextFieldFocused)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.xl)
                        .fill(.regularMaterial)
                    
                    RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.xl)
                        .stroke(
                            isTextFieldFocused ? 
                                Color.blue.opacity(0.5) : 
                                Color.white.opacity(0.2),
                            lineWidth: isTextFieldFocused ? 1.5 : 0.5
                        )
                        .animation(.glassEaseInOut, value: isTextFieldFocused)
                }
            )

            // Send/Stop button
            Button {
                performHapticFeedback(style: .medium)
                
                if isRunning {
                    task?.cancel()
                    removeTask()
                } else {
                    task = Task {
                        await sendButtonAction()
                        removeTask()
                    }
                }
            } label: {
                ZStack {
                    if isRunning {
                        // Stop button with pulsing effect
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.red)
                    } else {
                        // Send button
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .blue)
                    }
                }
                .frame(width: 44, height: 44)
                .background(
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                        
                        if isRunning {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)],
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 22
                                    )
                                )
                        } else if !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 22
                                    )
                                )
                        }
                    }
                )
                .overlay(
                    Circle()
                        .stroke(
                            isRunning ? Color.red.opacity(0.3) : 
                            (!prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.blue.opacity(0.3) : Color.white.opacity(0.2)), 
                            lineWidth: 1
                        )
                )
                .scaleEffect(sendButtonPressed ? 0.9 : 1.0)
                .animation(.glassBounce, value: sendButtonPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isRunning)
            .keyboardShortcut(isRunning ? .cancelAction : .defaultAction)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.glassEaseInOut) {
                    sendButtonPressed = pressing
                }
            }, perform: {})
        }
        .padding(.horizontal, GlassDesignSystem.Spacing.large)
        .padding(.vertical, GlassDesignSystem.Spacing.medium)
    }

    private var isRunning: Bool {
        task != nil && !(task!.isCancelled)
    }

    private func removeTask() {
        task = nil
    }
}


#Preview {
    PromptField(prompt: .constant("")) {
    } mediaButtonAction: {
    }
}
