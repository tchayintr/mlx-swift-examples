//
//  ChatToolbarView.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Futuristic toolbar view for the chat interface with glass morphism design
struct ChatToolbarView: View {
    /// View model containing the chat state and controls
    @Bindable var vm: ChatViewModel

    var body: some View {
        // Display error message if present
        if let errorMessage = vm.errorMessage {
            ErrorView(errorMessage: errorMessage)
        }

        // Show download progress for model loading
        if let progress = vm.modelDownloadProgress, !progress.isFinished {
            DownloadProgressView(progress: progress)
        }

        // Display-only generation statistics (no longer clickable for clearing)
        GenerationInfoView(tokensPerSecond: vm.tokensPerSecond)

        // Futuristic model selection
        FuturisticModelSelector(selectedModel: $vm.selectedModel)
    }
}
