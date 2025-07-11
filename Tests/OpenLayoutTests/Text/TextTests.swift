//
//  TextTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import OpenLayoutText
import XCTest

@MainActor
final class TextTests: XCTestCase {
    func testCoreTextLayoutEngine() {
        let engine = CoreTextLayoutEngine()
        let attributes = TextAttributes()
        
        // Test simple text
        let size = engine.sizeThatFits(
            .unspecified,
            text: "Hello, World!",
            attributes: attributes
        )
        // Replace the following with the actual values you see printed
        XCTAssertEqual(size.width, 68.47265625, accuracy: 0.5)
        XCTAssertEqual(size.height, 12.0, accuracy: 0.5)
        
        // Test with width constraint
        let constrainedSize = engine.sizeThatFits(
            ProposedSize(width: 50, height: nil),
            text: "This is a longer text that should wrap to multiple lines",
            attributes: attributes
        )
        // Replace the following with the actual values you see printed
        XCTAssertEqual(constrainedSize.width, 48.01171875, accuracy: 0.5)
        XCTAssertEqual(constrainedSize.height, 84.0, accuracy: 0.5)
    }
    
    func testEmptyString() {
        let engine = CoreTextLayoutEngine()
        let attributes = TextAttributes()
        
        // Test empty string
        let emptySize = engine.sizeThatFits(
            .unspecified,
            text: "",
            attributes: attributes
        )
        
        // Empty string should have zero width but height based on font metrics
        XCTAssertEqual(emptySize.width, 0.0, accuracy: 0.1)
        XCTAssertEqual(emptySize.height, 12.0, accuracy: 0.5) // Default font height
    }
}
