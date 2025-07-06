# Thai Character Display Fix for MLX Swift

## Issue Description

Thai combining characters (vowels and tone marks) were not displaying correctly in LLM responses within the MLX Swift chat application. Specifically:

- **Problem**: Characters like ั (U+E31), ี (U+E35), ้ (U+E49), ่ (U+E48), ็ (U+E47), ุ (U+E38) were missing from generated text
- **Symptoms**: Text like "สวัสดีครับ" (Hello in Thai) would display as "สวสดครบ" - missing vowels and tone marks
- **Scope**: Affected both pure Thai text and mixed Thai-English text

## Root Cause Analysis

The issue was in the `NaiveStreamingDetokenizer` class in `Libraries/MLXLMCommon/Tokenizer.swift`. The problem occurred in the text chunk calculation logic:

### Technical Details

1. **Character Count vs Unicode Scalar Count Mismatch**:
   - Thai combining characters don't increase Swift's character count (extended grapheme clusters)
   - But they do increase Unicode scalar count
   - Example: "สว" (2 chars) + "ั" = "สวั" (still 2 chars, but 3 Unicode scalars)

2. **Faulty Calculation**:
   ```swift
   // Original problematic code
   let new = newSegment.suffix(newSegment.count - segment.count)
   ```
   - When combining character added: `suffix(2 - 2)` = `suffix(0)` = empty string
   - Result: combining characters were lost in the calculation

3. **Character Boundary Issues**:
   - Even with correct count, `suffix()` operates on character boundaries
   - For "สวั", `suffix(1)` returns "วั" (entire combined character) instead of just "ั"

## Investigation Process

1. **Added comprehensive debug logging** to track token processing
2. **Identified that tokens were correctly decoded** but chunks became empty
3. **Discovered the count calculation discrepancy** between character count and Unicode scalar count
4. **Found the character boundary issue** with suffix extraction

## Solution Implementation

### Core Fix

Modified the `next()` function in `NaiveStreamingDetokenizer` to:

1. **Detect Thai text** using Unicode range check (U+0E01-U+0E7F)
2. **Use Unicode scalar count** instead of character count for Thai text
3. **Extract Unicode scalars directly** to avoid character boundary issues

### Code Changes

**File**: `Libraries/MLXLMCommon/Tokenizer.swift`

**Added helper function**:
```swift
/// Checks if a string contains ANY Thai characters
/// Used to determine whether to apply Thai-specific text processing
private func containsThaiCharacters(_ text: String) -> Bool {
    // Thai Unicode range: U+0E01-U+0E7F
    let thaiRange = UnicodeScalar(0x0E01)!...UnicodeScalar(0x0E7F)!
    
    return text.unicodeScalars.contains { scalar in
        thaiRange.contains(scalar)
    }
}
```

**Modified the main logic**:
```swift
public mutating func next() -> String? {
    let newSegment = tokenizer.decode(tokens: segmentTokens)
    
    // Use Unicode scalar count for Thai text to properly handle combining characters
    let isThaiText = containsThaiCharacters(newSegment) || containsThaiCharacters(segment)
    let countDiff = isThaiText ? 
        newSegment.unicodeScalars.count - segment.unicodeScalars.count :
        newSegment.count - segment.count
    
    // For Thai text, extract new Unicode scalars directly to avoid character boundary issues
    let new: String
    if isThaiText && countDiff > 0 {
        // Extract the new Unicode scalars directly
        let newScalars = Array(newSegment.unicodeScalars.suffix(countDiff))
        new = String(String.UnicodeScalarView(newScalars))
    } else {
        new = String(newSegment.suffix(countDiff))
    }

    // Handle replacement characters
    if new.last == "\u{fffd}" {
        return nil
    }

    if new.hasSuffix("\n") {
        startNewSegment()
    } else {
        self.segment = newSegment
    }

    return new
}
```

## Files Modified

1. **Libraries/MLXLMCommon/Tokenizer.swift**
   - Added `containsThaiCharacters()` helper function
   - Modified `next()` function with Thai-specific logic

## How the Fix Works

1. **Detection**: Checks if text contains Thai characters using Unicode range
2. **Count Calculation**: Uses Unicode scalar count for Thai text, character count for others  
3. **Extraction**: For Thai text, extracts Unicode scalars directly to preserve combining characters
4. **Compatibility**: Non-Thai text continues to use original logic

## Benefits

- ✅ **Thai combining characters display correctly**
- ✅ **Mixed Thai-English text works properly**
- ✅ **No impact on non-Thai languages**
- ✅ **Minimal code changes with targeted fix**

## Testing

The fix has been tested with:
- Pure Thai text: "สวัสดีครับ"
- Mixed language text: "Hello สวัสดี"
- Complex Thai with multiple combining characters
- English text (unchanged behavior)

## Reproduction Steps

To apply this fix to a fresh MLX Swift codebase:

1. Open `Libraries/MLXLMCommon/Tokenizer.swift`
2. Add the `containsThaiCharacters()` helper function after line ~146
3. Replace the entire `next()` function in `NaiveStreamingDetokenizer` with the fixed version
4. Test with Thai text input

## Technical Notes

- **Unicode Range**: Thai characters occupy U+0E01-U+0E7F
- **Combining Characters**: Include tone marks, upper vowels, and diacritical marks
- **Performance**: Minimal impact as detection only runs when Thai characters are present
- **Compatibility**: Maintains full backward compatibility with existing functionality

---

**Fix implemented on**: 2025-01-06  
**MLX Swift Version**: Compatible with current mlx-swift-examples repository  
**Tested Platforms**: iOS, macOS