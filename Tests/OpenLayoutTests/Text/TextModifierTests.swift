//
//  TextModifierTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import OpenLayoutText
import XCTest

@MainActor
final class TextModifierTests: XCTestCase {
    func testFontModifier() {
        let customFont = Font(name: "Arial", size: 16)
        
        Utils.assertLeafLayout(
            Text("Hello World!")
                .id(1)
                .font(customFont),
            expectedLayout: """
            1: 6.6 41.0 86.8 18.0
            """
        )
    }
    
    func testFontModifierWithBackground() {
        let customFont = Font(name: "Arial", size: 16)
        
        Utils.assertLeafLayout(
            Text("Hello World!")
                .id(1)
                .font(customFont)
                .background(
                    Rectangle()
                        .id(2)
                ),
            expectedLayout: """
            1: 6.6 41.0 86.8 18.0
            2: 6.6 41.0 86.8 18.0
            """
        )
    }
    
    func testFontModifierWithDifferentFont() {
        let smallFont = Font(name: "Arial", size: 10)
        let largeFont = Font(name: "Arial", size: 20)
        
        let layout = VStack(alignment: .center, spacing: 5) {
            Text("Hello World!")
                .id(1)
                .font(smallFont)
            Text("Hello World!")
                .id(2)
                .font(largeFont)
        }
        
        Utils.assertLeafLayout(
            layout,
            expectedLayout: """
            1: 22.9 18.5 54.3 12.0
            2: 21.3 35.5 57.4 46.0
            """
        )
    }
    
    func testFontModifierWithFrame() {
        let customFont = Font(name: "Arial", size: 16)
        
        Utils.assertLeafLayout(
            Text("Hello World!")
                .id(1)
                .font(customFont)
                .frame(width: 100, height: 30),
            expectedLayout: """
            1: 6.6 41.0 86.8 18.0
            """
        )
    }
}
