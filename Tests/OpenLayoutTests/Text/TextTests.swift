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
        XCTAssertEqual(size.width, 68.47265625, accuracy: 0.0001)
        XCTAssertEqual(size.height, 15.0, accuracy: 0.0001)
        
        // Test with width constraint
        let constrainedSize = engine.sizeThatFits(
            ProposedSize(width: 50, height: nil),
            text: "This is a longer text that should wrap to multiple lines",
            attributes: attributes
        )
        // Replace the following with the actual values you see printed
        XCTAssertEqual(constrainedSize.width, 44.677734375, accuracy: 0.0001)
        XCTAssertEqual(constrainedSize.height, 105.0, accuracy: 0.0001)
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
    
    func testTextDSL() {
        Utils.assertLeafLayout(
            Text("Hello world! I am very long text and should be wrapped. Also abc abc abc")
                .id(1),
            expectedLayout: """
            1: 1.0 12.5 98.1 75.0
            """
        )
    }
    
    func testTextLayoutInFrame() {
        Utils.assertLeafLayout(
            Text("""
            Hello world! I am very long text and should be wrapped. \
            Also abc abc abc abc abc abc abd abc abc.
            """)
            .id(1)
            .frame(width: 50),
            expectedLayout: """
            1: 27.3 5.0 45.4 90.0
            """
        )
    }
    
    func testComplexTextLayout() {
        Utils.assertLeafLayout(
            HStack(alignment: .top) {
                Text("Short left").id(1)
                VStack(alignment: .left) {
                    Text("A much longer string that should wrap to multiple lines in the vertical stack.").id(2)
                    Text("Another line, also long enough to wrap.").id(3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .left),
            expectedLayout: """
            1: 0.0 1.0 28.7 30.0
            2: 36.7 1.0 52.7 45.0
            3: 36.7 54.0 47.4 45.0
            """
        )
    }
}
