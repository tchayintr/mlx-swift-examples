//
//  ChatView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import AVFoundation
import AVKit
import SwiftUI

/// Main chat interface view with futuristic glass morphism design and floating elements.
/// Displays messages, handles media attachments, and provides input controls.
struct ChatView: View {
    /// View model that manages the chat state and business logic
    @Bindable private var vm: ChatViewModel
    
    @State private var showNewChatButton = true

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
                
                // Floating New Chat Button
                VStack {
                    HStack {
                        Spacer()
                        
                        if showNewChatButton {
                            GlassNewChatButton {
                                withAnimation(.glassSpring) {
                                    vm.clear([.chat, .meta])
                                }
                            }
                            .padding(.trailing, GlassDesignSystem.Spacing.xl)
                            .padding(.top, GlassDesignSystem.Spacing.medium)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("ChindaGo")
            .glassNavigation()
            .toolbar {
                ChatToolbarView(vm: vm)
            }
            // Handle media file selection
            .fileImporter(
                isPresented: $vm.mediaSelection.isShowing,
                allowedContentTypes: [.image, .movie],
                onCompletion: vm.addMedia
            )
            // Hide new chat button when generating
            .onChange(of: vm.isGenerating) { _, isGenerating in
                withAnimation(.glassEaseInOut) {
                    showNewChatButton = !isGenerating
                }
            }
            // Hide new chat button when typing
            .onChange(of: vm.prompt) { _, newPrompt in
                withAnimation(.glassEaseInOut) {
                    showNewChatButton = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
            }
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel(mlxService: MLXService()))
}
