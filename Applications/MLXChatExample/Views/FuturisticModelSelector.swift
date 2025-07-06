//
//  FuturisticModelSelector.swift
//  MLXChatExample
//
//  Created by tchayintr on 06.07.2025.
//

import SwiftUI

/// Futuristic model selection interface with glass morphism design
struct FuturisticModelSelector: View {
    @Binding var selectedModel: LMModel
    @State private var isShowingSelector = false
    @State private var animateSelection = false
    
    var body: some View {
        Button(action: {
            withAnimation(.glassSpring) {
                isShowingSelector.toggle()
            }
        }) {
            HStack(spacing: GlassDesignSystem.Spacing.small) {
                // Model icon
                Image(systemName: selectedModel.isVisionModel ? "eye.fill" : "brain.head.profile")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                
                // Model name
                Text(selectedModel.displayName)
                    .font(.glassButton)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Dropdown indicator
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(isShowingSelector ? 180 : 0))
                    .animation(.glassEaseInOut, value: isShowingSelector)
            }
            .padding(.horizontal, GlassDesignSystem.Spacing.medium)
            .padding(.vertical, GlassDesignSystem.Spacing.small)
            .glassPrimary()
            .scaleEffect(animateSelection ? 1.05 : 1.0)
            .animation(.glassBounce, value: animateSelection)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowingSelector) {
            ModelSelectionSheet(
                selectedModel: $selectedModel,
                onSelection: {
                    withAnimation(.glassBounce) {
                        animateSelection = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateSelection = false
                    }
                }
            )
            .glassSheet()
        }
    }
}

/// Sheet containing the model selection interface
struct ModelSelectionSheet: View {
    @Binding var selectedModel: LMModel
    @Environment(\.dismiss) private var dismiss
    let onSelection: () -> Void
    
    @State private var searchText = ""
    
    var filteredModels: [LMModel] {
        if searchText.isEmpty {
            return MLXService.availableModels
        }
        return MLXService.availableModels.filter { model in
            model.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Glass background
                Color.clear
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: GlassDesignSystem.Spacing.large) {
                    // Search field
                    SearchField(text: $searchText)
                    
                    // Model grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: GlassDesignSystem.Spacing.medium) {
                            ForEach(filteredModels) { model in
                                ModelCard(
                                    model: model,
                                    isSelected: model.id == selectedModel.id,
                                    action: {
                                        selectedModel = model
                                        onSelection()
                                        dismiss()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Select Model")
            .glassNavigation()
            .glassToolbar {
                Button("Done") {
                    dismiss()
                }
                .font(.glassButton)
            }
        }
    }
}

/// Individual model selection card
struct ModelCard: View {
    let model: LMModel
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            performHapticFeedback(style: .light)
            action()
        }) {
            VStack(spacing: GlassDesignSystem.Spacing.small) {
                // Model type icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: model.isVisionModel ? 
                                    [Color.purple.opacity(0.3), Color.blue.opacity(0.1)] :
                                    [Color.blue.opacity(0.3), Color.cyan.opacity(0.1)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: model.isVisionModel ? "eye.fill" : "brain.head.profile")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(model.isVisionModel ? .purple : .blue)
                }
                
                // Model name
                Text(model.displayName)
                    .font(.glassCaption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Selection indicator
                if isSelected {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("Selected")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(GlassDesignSystem.Spacing.medium)
            .frame(height: 120)
            .glassPrimary()
            .overlay(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.large)
                    .stroke(
                        isSelected ? Color.green.opacity(0.5) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.glassEaseInOut, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.glassEaseInOut) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

/// Glass-styled search field
struct SearchField: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16, weight: .medium))
            
            TextField("Search models...", text: $text)
                .font(.glassChatText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, GlassDesignSystem.Spacing.medium)
        .padding(.vertical, GlassDesignSystem.Spacing.small)
        .glassInputField()
    }
}

#Preview {
    FuturisticModelSelector(selectedModel: .constant(MLXService.availableModels.first!))
}