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
                
                // Model name with truncation for fixed width
                Text(selectedModel.displayName)
                    .font(.glassButton)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
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
            #if os(iOS)
            ZStack {
                // Glass background
                Color.clear
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: GlassDesignSystem.Spacing.large) {
                    // Search field
                    SearchField(text: $searchText)
                    
                    // Model list
                    List(filteredModels) { model in
                        ModelListRow(
                            model: model,
                            isSelected: model.id == selectedModel.id,
                            action: {
                                selectedModel = model
                                onSelection()
                                dismiss()
                            }
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
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
            #else
            VStack(spacing: GlassDesignSystem.Spacing.large) {
                // Search field
                SearchField(text: $searchText)
                
                // Model list using ScrollView for better macOS compatibility
                ScrollView {
                    LazyVStack(spacing: GlassDesignSystem.Spacing.xs) {
                        ForEach(filteredModels) { model in
                            ModelListRow(
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
                .frame(maxHeight: 400) // Explicit height for ScrollView
            }
            .padding()
            .navigationTitle("Select Model")
            .glassNavigation()
            .glassToolbar {
                Button("Done") {
                    dismiss()
                }
                .font(.glassButton)
            }
            #endif
        }
    }
}

/// Individual model selection row for list display
struct ModelListRow: View {
    let model: LMModel
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            performHapticFeedback(style: .light)
            action()
        }) {
            HStack(spacing: GlassDesignSystem.Spacing.medium) {
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
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: model.isVisionModel ? "eye.fill" : "brain.head.profile")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(model.isVisionModel ? .purple : .blue)
                }
                
                // Model information
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.displayName)
                        .font(.glassChatText)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if model.isVisionModel {
                        Text("Vision Model")
                            .font(.glassCaption)
                            .foregroundColor(.purple)
                    } else {
                        Text("Language Model")
                            .font(.glassCaption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, GlassDesignSystem.Spacing.small)
            .padding(.horizontal, GlassDesignSystem.Spacing.medium)
            #if os(iOS)
            .background(
                RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        // Only show border when selected
                        isSelected ? 
                        RoundedRectangle(cornerRadius: GlassDesignSystem.CornerRadius.medium)
                            .stroke(Color.green.opacity(0.5), lineWidth: 2) :
                        nil
                    )
            )
            #else
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? Color.accentColor : Color.gray.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .frame(minHeight: 60) // Ensure minimum height for visibility
            #endif
            .scaleEffect(isPressed ? 0.98 : 1.0)
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