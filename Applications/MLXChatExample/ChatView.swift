//
//  ChatView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import AVFoundation
import AVKit
import SwiftUI

/// Main chat interface view with futuristic glass morphism design.
/// Displays messages, handles media attachments, and provides input controls.
struct ChatView: View {
    /// View model that manages the chat state and business logic
    @Bindable private var vm: ChatViewModel

    /// Initializes the chat view with a view model
    /// - Parameter viewModel: The view model to manage chat state
    init(viewModel: ChatViewModel) {
        self.vm = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Glass background
                Color.clear
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Display conversation history
                    ConversationView(messages: vm.messages)
                        .background(.clear)
                        .onTapGesture {
                            // Dismiss keyboard when tapping chat area
                            #if os(iOS)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            #endif
                        }

                    // Glass divider
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(height: 1)
                        .opacity(0.3)

                    // Show media previews if attachments are present
                    if !vm.mediaSelection.isEmpty {
                        MediaPreviewsView(mediaSelection: vm.mediaSelection)
                            .padding(.horizontal, GlassDesignSystem.Spacing.medium)
                            .glassPrimary()
                            .padding(.horizontal, GlassDesignSystem.Spacing.large)
                            .padding(.top, GlassDesignSystem.Spacing.small)
                    }

                    // Input field with glass styling
                    PromptField(
                        prompt: $vm.prompt,
                        sendButtonAction: vm.generate,
                        // Only show media button for vision-capable models
                        mediaButtonAction: vm.selectedModel.isVisionModel
                            ? {
                                vm.mediaSelection.isShowing = true
                            } : nil
                    )
                    .background(.regularMaterial.opacity(0.8))
                }
            }
            .glassNavigation()
            .glassToolbarLeading {
                HStack(spacing: GlassDesignSystem.Spacing.small) {
                    // Logo icon positioned at leftmost
                    Image(systemName: "applelogo")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    // Error and download progress indicators (separated from logo)
                    if let errorMessage = vm.errorMessage {
                        ErrorView(errorMessage: errorMessage)
                    }
                    
                    if let progress = vm.modelDownloadProgress, !progress.isFinished {
                        DownloadProgressView(progress: progress)
                    }
                }
            }
            .glassToolbarPrincipal {
                // Model selector always centered on both platforms
                FuturisticModelSelector(selectedModel: $vm.selectedModel)
                    .frame(width: 180) // Fixed width
            }
            .toolbar {
                // Speed indicator
                ToolbarItem(placement: .automatic) {
                    GenerationInfoView(tokensPerSecond: vm.tokensPerSecond)
                }
                
                // New Chat button - rightmost position
                ToolbarItem(placement: .primaryAction) {
                    CompactNewChatButton {
                        vm.clear([.chat, .meta])
                    }
                }
            }
            // Handle media file selection
            .fileImporter(
                isPresented: $vm.mediaSelection.isShowing,
                allowedContentTypes: [.image, .movie],
                onCompletion: vm.addMedia
            )
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel(mlxService: MLXService()))
}
