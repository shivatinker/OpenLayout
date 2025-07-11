//
//  VStackLayoutTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

@MainActor
final class VStackLayoutTests: XCTestCase {
    func testBasicVStack() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle().id(1)
                Rectangle().id(2)
            },
            expectedLayout: """
            1: 0.0 0.0 100.0 46.0
            2: 0.0 54.0 100.0 46.0
            """
        )
    }
    
    func testVStackWithSpacing() {
        Utils.assertLeafLayout(
            VStack(spacing: 20) {
                Rectangle().id(1)
                Rectangle().id(2)
                Rectangle().id(3)
            },
            expectedLayout: """
            1: 0.0 0.0 100.0 20.0
            2: 0.0 40.0 100.0 20.0
            3: 0.0 80.0 100.0 20.0
            """
        )
    }
    
    func testVStackWithFixedSizeChildren() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle().id(1).frame(width: 30, height: 20)
                Rectangle().id(2).frame(width: 40, height: 30)
            },
            expectedLayout: """
            1: 35.0 21.0 30.0 20.0
            2: 30.0 49.0 40.0 30.0
            """
        )
    }
    
    func testVStackWithFlexibleFrame() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle().id(1).frame(minHeight: 20, maxHeight: 40)
                Rectangle().id(2).frame(minHeight: 30, maxHeight: 50)
            },
            expectedLayout: """
            1: 0.0 1.0 100.0 40.0
            2: 0.0 49.0 100.0 50.0
            """
        )
    }
    
    func testVStackWithPadding() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle().id(1).padding(10)
                Rectangle().id(2).padding(5)
            },
            expectedLayout: """
            1: 10.0 10.0 80.0 26.0
            2: 5.0 59.0 90.0 36.0
            """
        )
    }
    
    func testSingleChildVStack() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle().id(1)
            },
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }
    
    func testEmptyVStack() {
        Utils.assertLeafLayout(
            VStack {},
            expectedLayout: ""
        )
    }
    
    // MARK: - Alignment Tests
    
    func testVStackWithLeftAlignment() {
        Utils.assertLeafLayout(
            VStack(alignment: .left, spacing: 8) {
                Rectangle().id(1).frame(width: 30, height: 20)
                Rectangle().id(2).frame(width: 40, height: 25)
                Rectangle().id(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 30.0 12.0 30.0 20.0
            2: 30.0 40.0 40.0 25.0
            3: 30.0 73.0 25.0 15.0
            """
        )
    }
    
    func testVStackWithCenterAlignment() {
        Utils.assertLeafLayout(
            VStack(alignment: .center, spacing: 8) {
                Rectangle().id(1).frame(width: 30, height: 20)
                Rectangle().id(2).frame(width: 40, height: 25)
                Rectangle().id(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 35.0 12.0 30.0 20.0
            2: 30.0 40.0 40.0 25.0
            3: 37.5 73.0 25.0 15.0
            """
        )
    }
    
    func testVStackWithRightAlignment() {
        Utils.assertLeafLayout(
            VStack(alignment: .right, spacing: 8) {
                Rectangle().id(1).frame(width: 30, height: 20)
                Rectangle().id(2).frame(width: 40, height: 25)
                Rectangle().id(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 40.0 12.0 30.0 20.0
            2: 30.0 40.0 40.0 25.0
            3: 45.0 73.0 25.0 15.0
            """
        )
    }
    
    func testVStackWithAlignmentAndSpacing() {
        Utils.assertLeafLayout(
            VStack(alignment: .center, spacing: 10) {
                Rectangle().id(1).frame(width: 25, height: 15)
                Rectangle().id(2).frame(width: 35, height: 20)
                Rectangle().id(3).frame(width: 20, height: 12)
            }
            .frame(width: 100, height: 100),
            expectedLayout: """
            1: 37.5 16.5 25.0 15.0
            2: 32.5 41.5 35.0 20.0
            3: 40.0 71.5 20.0 12.0
            """
        )
    }
    
    func testMixedVStack() {
        Utils.assertLeafLayout(
            HStack(alignment: .bottom, spacing: 5) {
                Rectangle().id(1).frame(height: 15)
                    .frame(minWidth: 10, maxWidth: 30)
            },
            expectedLayout: """
            1: 35.0 42.5 30.0 15.0
            """
        )
    }
}
