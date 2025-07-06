//
//  ThaiCharacterTests.swift
//  MLXLMTests
//
//  Created by Assistant on 07.01.2025.
//

import XCTest
@testable import MLXLMCommon
import MLX
import Tokenizers

final class ThaiCharacterTests: XCTestCase {
    
    /// Test Thai character Unicode ranges detection
    func testThaiUnicodeRanges() {
        let thaiText = "สวัสดี"  // Hello in Thai with tone mark
        let englishText = "Hello"
        
        let hasThaiChars = thaiText.unicodeScalars.contains { scalar in
            (0x0E01...0x0E7F).contains(scalar.value)
        }
        
        let hasEnglishChars = englishText.unicodeScalars.contains { scalar in
            (0x0E01...0x0E7F).contains(scalar.value)
        }
        
        XCTAssertTrue(hasThaiChars, "Thai text should contain Thai Unicode characters")
        XCTAssertFalse(hasEnglishChars, "English text should not contain Thai Unicode characters")
    }
    
    /// Test Thai combining character detection
    func testThaiCombiningCharacters() {
        let thaiWithToneMark = "ไก่"  // Chicken with tone mark (ไ + ก + ่)
        let thaiWithoutToneMark = "กก"  // Just consonants
        
        let combiningRanges: [ClosedRange<UnicodeScalar>] = [
            UnicodeScalar(0x0E31)!...UnicodeScalar(0x0E31)!, // MAI HAN-AKAT
            UnicodeScalar(0x0E34)!...UnicodeScalar(0x0E3A)!, // Upper vowels and tone marks
            UnicodeScalar(0x0E47)!...UnicodeScalar(0x0E4E)!  // Additional combining marks
        ]
        
        let hasCombining = thaiWithToneMark.unicodeScalars.contains { scalar in
            combiningRanges.contains { range in
                range.contains(scalar)
            }
        }
        
        let hasNoCombining = thaiWithoutToneMark.unicodeScalars.contains { scalar in
            combiningRanges.contains { range in
                range.contains(scalar)
            }
        }
        
        XCTAssertTrue(hasCombining, "Thai text with tone marks should contain combining characters")
        XCTAssertFalse(hasNoCombining, "Thai text without tone marks should not contain combining characters")
    }
    
    /// Test for replacement character detection
    func testReplacementCharacterDetection() {
        let textWithReplacement = "Hello\u{fffd}World"
        let textWithoutReplacement = "HelloWorld"
        
        XCTAssertTrue(textWithReplacement.contains("\u{fffd}"), "Text should contain replacement character")
        XCTAssertFalse(textWithoutReplacement.contains("\u{fffd}"), "Text should not contain replacement character")
    }
    
    /// Test Thai text with various problematic sequences
    func testProblematicThaiSequences() {
        let problematicSequences = [
            "ไก่",     // Chicken
            "ผี",      // Ghost
            "ใหม่",    // New
            "ไม่",     // No/not
            "ที่นี่",   // Here
            "เรื่อง",   // Story
            "ผู้ใหญ่",  // Adult
            "ความเป็นไปได้"  // Possibility
        ]
        
        for sequence in problematicSequences {
            XCTAssertFalse(sequence.isEmpty, "Thai sequence should not be empty")
            XCTAssertFalse(sequence.contains("\u{fffd}"), "Thai sequence should not contain replacement characters")
            
            // Check that it contains Thai characters
            let containsThaiChars = sequence.unicodeScalars.contains { scalar in
                (0x0E01...0x0E7F).contains(scalar.value)
            }
            XCTAssertTrue(containsThaiChars, "Sequence '\(sequence)' should contain Thai characters")
        }
    }
    
    /// Test Unicode scalar value ranges for Thai characters
    func testThaiUnicodeScalarValues() {
        let thaiConsonant = "ก"  // U+0E01
        let thaiVowel = "า"      // U+0E32
        let thaiToneMark = "่"   // U+0E48
        
        XCTAssertEqual(thaiConsonant.unicodeScalars.first?.value, 0x0E01)
        XCTAssertEqual(thaiVowel.unicodeScalars.first?.value, 0x0E32)
        XCTAssertEqual(thaiToneMark.unicodeScalars.first?.value, 0x0E48)
    }
    
    /// Test Thai character normalization
    func testThaiCharacterNormalization() {
        let originalText = "สวัสดี"
        let normalizedNFC = originalText.precomposedStringWithCanonicalMapping
        let normalizedNFD = originalText.decomposedStringWithCanonicalMapping
        
        XCTAssertFalse(originalText.isEmpty)
        XCTAssertFalse(normalizedNFC.isEmpty)
        XCTAssertFalse(normalizedNFD.isEmpty)
        
        // The character count might differ between NFC and NFD due to combining characters
        print("Original: '\(originalText)' (count: \(originalText.count))")
        print("NFC: '\(normalizedNFC)' (count: \(normalizedNFC.count))")
        print("NFD: '\(normalizedNFD)' (count: \(normalizedNFD.count))")
    }
}