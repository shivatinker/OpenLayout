//
//  VStackLayoutTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

final class VStackLayoutTests: XCTestCase {
    func testBasicVStack() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle(1)
                Rectangle(2)
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
                Rectangle(1)
                Rectangle(2)
                Rectangle(3)
            },
            expectedLayout: """
            1: 0.0 0.0 100.0 28.0
            2: 0.0 36.0 100.0 28.0
            3: 0.0 72.0 100.0 28.0
            """
        )
    }
    
    func testVStackWithFixedSizeChildren() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle(1).frame(width: 30, height: 20)
                Rectangle(2).frame(width: 40, height: 30)
            },
            expectedLayout: """
            1: 21.0 30.0 30.0 20.0
            2: 21.0 68.0 40.0 30.0
            """
        )
    }
    
    func testVStackWithFlexibleFrame() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle(1).frame(minHeight: 20, maxHeight: 40)
                Rectangle(2).frame(minHeight: 30, maxHeight: 50)
            },
            expectedLayout: """
            1: 1.0 0.0 98.0 40.0
            2: 1.0 54.0 98.0 46.0
            """
        )
    }
    
    func testVStackWithPadding() {
        Utils.assertLeafLayout(
            VStack {
                Rectangle(1).padding(10)
                Rectangle(2).padding(5)
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
                Rectangle(1)
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
}
