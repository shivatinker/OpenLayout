//
//  HStackLayoutTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

@MainActor
final class HStackLayoutTests: XCTestCase {
    func testBasicHStack() {
        Utils.assertLeafLayout(
            HStack {
                Rectangle(1)
                Rectangle(2)
            },
            expectedLayout: """
            1: 0.0 0.0 46.0 100.0
            2: 54.0 0.0 46.0 100.0
            """
        )
    }
    
    func testHStackWithSpacing() {
        Utils.assertLeafLayout(
            HStack(spacing: 20) {
                Rectangle(1)
                Rectangle(2)
                Rectangle(3)
            },
            expectedLayout: """
            1: 0.0 0.0 20.0 100.0
            2: 40.0 0.0 20.0 100.0
            3: 80.0 0.0 20.0 100.0
            """
        )
    }
    
    func testHStackWithFixedSizeChildren() {
        Utils.assertLeafLayout(
            HStack {
                Rectangle(1).frame(width: 30, height: 20)
                Rectangle(2).frame(width: 40, height: 30)
            },
            expectedLayout: """
            1: 11.0 40.0 30.0 20.0
            2: 49.0 35.0 40.0 30.0
            """
        )
    }
    
    func testHStackWithFlexibleFrame() {
        Utils.assertLeafLayout(
            HStack {
                Rectangle(1).frame(minWidth: 20, maxWidth: 40)
                Rectangle(2).frame(minWidth: 30, maxWidth: 50)
            },
            expectedLayout: """
            1: 1.0 0.0 40.0 100.0
            2: 49.0 0.0 50.0 100.0
            """
        )
    }
    
    func testHStackWithPadding() {
        Utils.assertLeafLayout(
            HStack {
                Rectangle(1).padding(10)
                Rectangle(2).padding(5)
            },
            expectedLayout: """
            1: 10.0 10.0 26.0 80.0
            2: 59.0 5.0 36.0 90.0
            """
        )
    }
    
    func testSingleChildHStack() {
        Utils.assertLeafLayout(
            HStack {
                Rectangle(1)
            },
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }
    
    func testEmptyHStack() {
        Utils.assertLeafLayout(
            HStack {},
            expectedLayout: ""
        )
    }
    
    // MARK: - Alignment Tests
    
    func testHStackWithTopAlignment() {
        Utils.assertLeafLayout(
            HStack(alignment: .top, spacing: 8) {
                Rectangle(1).frame(width: 20, height: 30)
                Rectangle(2).frame(width: 30, height: 20)
                Rectangle(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 4.5 30.0 20.0 30.0
            2: 32.5 30.0 30.0 20.0
            3: 70.5 30.0 25.0 40.0
            """
        )
    }
    
    func testHStackWithCenterAlignment() {
        Utils.assertLeafLayout(
            HStack(alignment: .center, spacing: 8) {
                Rectangle(1).frame(width: 20, height: 30)
                Rectangle(2).frame(width: 30, height: 20)
                Rectangle(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 4.5 35.0 20.0 30.0
            2: 32.5 40.0 30.0 20.0
            3: 70.5 30.0 25.0 40.0
            """
        )
    }
    
    func testHStackWithBottomAlignment() {
        Utils.assertLeafLayout(
            HStack(alignment: .bottom, spacing: 8) {
                Rectangle(1).frame(width: 20, height: 30)
                Rectangle(2).frame(width: 30, height: 20)
                Rectangle(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 4.5 40.0 20.0 30.0
            2: 32.5 50.0 30.0 20.0
            3: 70.5 30.0 25.0 40.0
            """
        )
    }
    
    func testHStackWithAlignmentAndSpacing() {
        Utils.assertLeafLayout(
            HStack(alignment: .center, spacing: 10) {
                Rectangle(1).frame(width: 15, height: 25)
                Rectangle(2).frame(width: 20, height: 15)
                Rectangle(3).frame(width: 18, height: 35)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 13.5 37.5 15.0 25.0
            2: 38.5 42.5 20.0 15.0
            3: 68.5 32.5 18.0 35.0
            """
        )
    }
}
