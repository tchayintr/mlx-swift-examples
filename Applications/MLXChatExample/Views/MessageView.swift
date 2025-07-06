//
//  MessageView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import AVKit
import SwiftUI

/// A view that displays a single message in the chat interface with futuristic glass morphism design.
/// Supports different message roles (user, assistant, system) and media attachments.
struct MessageView: View {
    /// The message to be displayed
    let message: Message
    
    @State private var isVisible = false

    /// Creates a message view
    /// - Parameter message: The message model to display
    init(_ message: Message) {
        self.message = message
    }

    var body: some View {
        switch message.role {
        case .user:
            // User messages with glass morphism effect
            HStack(spacing: GlassDesignSystem.Spacing.medium) {
                Spacer(minLength: 40) // Create asymmetric spacing for modern look
                
                VStack(alignment: .trailing, spacing: GlassDesignSystem.Spacing.small) {
                    // Display first image if present
                    if let firstImage = message.images.first {
                        AsyncImage(url: firstImage) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                                .tint(.blue)
                        }
                        .frame(maxWidth: 250, maxHeight: 200)
                        .clipShape(.rect(cornerRadius: GlassDesignSystem.CornerRadius.medium))
                        .overlay(
                            RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // Display first video if present
                    if let firstVideo = message.videos.first {
                        VideoPlayer(player: AVPlayer(url: firstVideo))
                            .frame(width: 250, height: 340)
                            .clipShape(.rect(cornerRadius: GlassDesignSystem.CornerRadius.medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Message content with glass morphism background
                    if !message.content.isEmpty {
                        Text(LocalizedStringKey(message.content))
                            .font(.glassChatText)
                            .foregroundColor(.white)
                            .padding(.vertical, GlassDesignSystem.Spacing.medium)
                            .padding(.horizontal, GlassDesignSystem.Spacing.large)
                            .glassUserBubble()
                            .textSelection(.enabled)
                    }
                }
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .opacity(isVisible ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.glassSpring.delay(0.1)) {
                        isVisible = true
                    }
                }
            }

        case .assistant:
            // Assistant messages with elegant glass container
            HStack(spacing: GlassDesignSystem.Spacing.medium) {
                VStack(alignment: .leading, spacing: GlassDesignSystem.Spacing.small) {
                    if !message.content.isEmpty {
                        Text(message.content)
                            .font(.glassChatText)
                            .foregroundColor(.primary)
                            .padding(.vertical, GlassDesignSystem.Spacing.medium)
                            .padding(.horizontal, GlassDesignSystem.Spacing.large)
                            .glassAssistantBubble()
                            .textSelection(.enabled)
                    }
                }
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .opacity(isVisible ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.glassSpring.delay(0.1)) {
                        isVisible = true
                    }
                }
                
                Spacer(minLength: 40) // Create asymmetric spacing for modern look
            }

        case .system:
            // System messages with subtle glass effect (hidden by default but keeping for completeness)
            HStack {
                Spacer()
                
                Label(message.content, systemImage: "cpu")
                    .font(.glassCaption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, GlassDesignSystem.Spacing.small)
                    .padding(.horizontal, GlassDesignSystem.Spacing.medium)
                    .glassInfoCard()
                    .opacity(isVisible ? 0.7 : 0.0)
                    .onAppear {
                        withAnimation(.glassEaseInOut.delay(0.2)) {
                            isVisible = true
                        }
                    }
                
                Spacer()
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MessageView(.system("You are a helpful assistant."))

        MessageView(
            .user(
                "Here's a photo",
                images: [URL(string: "https://picsum.photos/200")!]
            )
        )

        MessageView(.assistant("I see your photo!"))
    }
    .padding()
}
