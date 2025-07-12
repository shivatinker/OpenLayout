//
//  BackgroundTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import OpenLayoutText
import XCTest

@MainActor
final class BackgroundTests: XCTestCase {
    
    func testSimpleBackground() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .background(Rectangle().id(2)),
            expectedLayout: """
            1: 0.0 0.0 100.0 100.0
            2: 0.0 0.0 100.0 100.0
            """
        )
    }
    
    func testBackgroundWithPadding() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .background(Rectangle().id(2).padding(10)),
            expectedLayout: """
            1: 0.0 0.0 100.0 100.0
            2: 10.0 10.0 80.0 80.0
            """
        )
    }
    
    func testBackgroundWithFrame() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 50, height: 30)
                .background(Rectangle().id(2)),
            expectedLayout: """
            1: 25.0 35.0 50.0 30.0
            2: 25.0 35.0 50.0 30.0
            """
        )
    }
    
    func testBackgroundWithText() {
        Utils.assertLeafLayout(
            Text("Hello World!")
                .id(1)
                .background(Rectangle().id(2)),
            expectedLayout: """
            1: 17.4 42.5 65.1 15.0
            2: 17.4 42.5 65.1 15.0
            """
        )
    }
    
    func testComplexBackground() {
        Utils.assertLeafLayout(
            VStack(alignment: .center, spacing: 5) {
                Rectangle().id(1)
                Rectangle().id(2)
            }
            .background(
                HStack(alignment: .center, spacing: 3) {
                    Rectangle().id(3)
                    Rectangle().id(4)
                }
            ),
            expectedLayout: """
            1: 0.0 0.0 100.0 47.5
            2: 0.0 52.5 100.0 47.5
            3: 0.0 0.0 48.5 100.0
            4: 51.5 0.0 48.5 100.0
            """
        )
    }
    
    func testBackgroundWithFlexibleFrame() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(minWidth: 50, maxWidth: 100, minHeight: 30, maxHeight: 60)
                .background(Rectangle().id(2)),
            expectedLayout: """
            1: 0.0 20.0 100.0 60.0
            2: 0.0 20.0 100.0 60.0
            """
        )
    }
    
    func testBackgroundWithStack() {
        Utils.assertLeafLayout(
            HStack(alignment: .center, spacing: 10) {
                Rectangle().id(1)
                Rectangle().id(2)
            }
            .background(Rectangle().id(3)),
            expectedLayout: """
            1: 0.0 0.0 45.0 100.0
            2: 55.0 0.0 45.0 100.0
            3: 0.0 0.0 100.0 100.0
            """
        )
    }
    
    func testNestedBackgrounds() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .background(Rectangle().id(2))
                .background(Rectangle().id(3)),
            expectedLayout: """
            1: 0.0 0.0 100.0 100.0
            2: 0.0 0.0 100.0 100.0
            3: 0.0 0.0 100.0 100.0
            """
        )
    }
    
    func testBackgroundWithEmptyContent() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 0, height: 0)
                .background(Rectangle().id(2)),
            expectedLayout: """
            1: 50.0 50.0 0.0 0.0
            2: 50.0 50.0 0.0 0.0
            """
        )
    }
    
    func testBackgroundWithLargeContent() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 200, height: 150)
                .background(Rectangle().id(2)),
            rect: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)),
            expectedLayout: """
            1: 50.0 25.0 200.0 150.0
            2: 50.0 25.0 200.0 150.0
            """
        )
    }
    
    // MARK: - Demonstration Tests
    
    func testBackgroundDemonstration() {
        // This test demonstrates the background modifier with visualization
        let layout = VStack(alignment: .center, spacing: 10) {
            Text("Hello World!")
                .id(1)
                .background(Rectangle().id(2))
            
            HStack(alignment: .center, spacing: 5) {
                Rectangle().id(3)
                Rectangle().id(4)
            }
            .background(Rectangle().id(5))
        }
        .padding(20)
        
        // The layout should work correctly
        Utils.assertLeafLayout(
            layout,
            rect: CGRect(origin: .zero, size: CGSize(width: 200, height: 150)),
            expectedLayout: """
            1: 67.4 20.0 65.1 15.0
            2: 67.4 20.0 65.1 15.0
            3: 20.0 45.0 77.5 85.0
            4: 102.5 45.0 77.5 85.0
            5: 20.0 45.0 160.0 85.0
            """
        )
    }
} 