# System Prompt Preservation Fix for MLX Swift Chat

## Issue Description

System prompts were being lost when clearing the chat (clicking the token throughput button), causing the model to lose its identity and behave like the base model instead of the configured persona.

- **Problem**: Model reverted to generic behavior after clearing chat
- **Symptoms**: Chinda LLM identity was lost, responses became generic instead of Thai-focused
- **Scope**: Affected all models when using the clear chat functionality

## Root Cause Analysis

The issue was in the `clear()` function in `ChatViewModel.swift`. When clearing chat history, the function was removing ALL messages including system prompts that define the model's identity.

### Technical Details

1. **Original Problematic Code**:
   ```swift
   if options.contains(.chat) {
       messages = []  // This removed EVERYTHING including system prompts
       generateTask?.cancel()
   }
   ```

2. **Why This Broke Model Identity**:
   - System prompts define the model's persona and behavior
   - Clearing all messages removed the foundational instructions
   - Model reverted to base behavior without guidance

3. **User Experience Impact**:
   - After clearing chat, model responses became generic
   - Lost Thai language preference and Chinda LLM identity
   - Appeared as if a different model was being used

## Solution Implementation

### Core Fix

Modified the clear function to preserve system messages while removing user/assistant conversation history.

**File**: `Applications/MLXChatExample/ViewModels/ChatViewModel.swift`

**Code Change**:
```swift
// Before: Clearing all messages including system prompts
if options.contains(.chat) {
    messages = []
    generateTask?.cancel()
}

// After: Preserving system messages when clearing chat
if options.contains(.chat) {
    messages = messages.filter { $0.role == .system }
    generateTask?.cancel()
}
```

## Technical Implementation

1. **Filter Logic**: `messages.filter { $0.role == .system }`
2. **Preservation**: System messages remain in the array
3. **Cleanup**: User and assistant messages are removed
4. **State Reset**: Generation task is still cancelled appropriately

## Files Modified

1. **Applications/MLXChatExample/ViewModels/ChatViewModel.swift**
   - Line 146: Modified clear function to preserve system messages

## How the Fix Works

1. **Before Clear**: Messages array contains system, user, and assistant messages
2. **Clear Action**: Filter keeps only messages where `role == .system`
3. **After Clear**: Chat history is clean but system prompt remains
4. **Model Behavior**: Maintains identity and persona through preserved system prompt

## Benefits

- ✅ **Model identity preserved after clearing chat**
- ✅ **System prompts remain functional across chat sessions**
- ✅ **Clean chat history without losing model configuration**
- ✅ **Consistent model behavior regardless of clear operations**
- ✅ **Simple, targeted fix with minimal code change**

## Example Scenario

**System Prompt**: "You are Chinda LLM, powering the ChindaGo app by iApp Technology. Respond helpfully and accurately, primarily in Thai."

**Before Fix**:
1. User chats with Chinda LLM (Thai responses)
2. User clicks token throughput button to clear chat
3. Model loses identity, responds in English/generic style

**After Fix**:
1. User chats with Chinda LLM (Thai responses)
2. User clicks token throughput button to clear chat
3. Model retains Chinda identity, continues Thai-focused responses

## Testing

The fix has been verified to:
- Preserve system prompts when clearing chat
- Remove all user and assistant conversation history
- Maintain model identity and behavior patterns
- Work correctly with the token throughput display functionality

## Reproduction Steps

To apply this fix to a fresh MLX Swift codebase:

1. Open `Applications/MLXChatExample/ViewModels/ChatViewModel.swift`
2. Locate the `clear()` function around line 139
3. Find the chat clearing logic: `if options.contains(.chat) {`
4. Replace `messages = []` with `messages = messages.filter { $0.role == .system }`
5. Test by setting a system prompt, chatting, clearing, and verifying behavior consistency

## Related Components

**Chat Clearing Trigger**: `Applications/MLXChatExample/Views/Toolbar/ChatToolbarView.swift`
```swift
Button {
    vm.clear([.chat, .meta])  // This calls the fixed clear function
} label: {
    GenerationInfoView(tokensPerSecond: vm.tokensPerSecond)
}
```

## Technical Notes

- **Message Roles**: System (.system), User (.user), Assistant (.assistant)
- **Clear Options**: Supports selective clearing via option flags
- **State Management**: Uses @Observable pattern for UI updates
- **Performance**: Minimal impact as filter operation is lightweight

---

**Fix implemented on**: 2025-01-06  
**Issue type**: Model Behavior Bug  
**Severity**: Medium (affected model identity but not core functionality)  
**Impact**: Improves model consistency across chat sessions