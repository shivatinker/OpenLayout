//
//  FixedFrameTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

@MainActor
final class FixedFrameTests: XCTestCase {
    // MARK: - Width Only Tests
    
    func testFixedWidthOnly() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(width: 50),
            expectedLayout: """
            1: 25.0 0.0 50.0 100.0
            """
        )
    }
    
    // MARK: - Height Only Tests
    
    func testFixedHeightOnly() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(height: 30),
            expectedLayout: """
            1: 0.0 35.0 100.0 30.0
            """
        )
    }
    
    // MARK: - Width and Height Tests
    
    func testFixedWidthAndHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(width: 60, height: 40),
            expectedLayout: """
            1: 20.0 30.0 60.0 40.0
            """
        )
    }
    
    // MARK: - Alignment Tests with Nested Frames
    
    private func assertWidthAlignment(
        _ alignment: Alignment,
        _ expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 50)
                .frame(width: 100, height: 100, alignment: alignment),
            expectedLayout: expected,
            file: file,
            line: line
        )
    }
    
    private func assertHeightAlignment(
        _ alignment: Alignment,
        _ expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(height: 30)
                .frame(width: 100, height: 100, alignment: alignment),
            expectedLayout: expected,
            file: file,
            line: line
        )
    }
    
    func testWidthOnlyWithAlignments() {
        self.assertWidthAlignment(.center, "1: 25.0 0.0 50.0 100.0")
        self.assertWidthAlignment(.left, "1: 0.0 0.0 50.0 100.0")
        self.assertWidthAlignment(.right, "1: 50.0 0.0 50.0 100.0")
    }
    
    func testHeightOnlyWithAlignments() {
        self.assertHeightAlignment(.center, "1: 0.0 35.0 100.0 30.0")
        self.assertHeightAlignment(.top, "1: 0.0 0.0 100.0 30.0")
        self.assertHeightAlignment(.bottom, "1: 0.0 70.0 100.0 30.0")
    }
    
    // MARK: - Alignment Utility
    
    private func assertAlignment(
        _ alignment: Alignment,
        _ expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(width: 100, height: 100, alignment: alignment),
            expectedLayout: expected,
            file: file,
            line: line
        )
    }

    func testFixedWidthAndHeightWithAlignments() {
        self.assertAlignment(.center, "1: 20.0 30.0 60.0 40.0")
        self.assertAlignment(.topLeft, "1: 0.0 0.0 60.0 40.0")
        self.assertAlignment(.top, "1: 20.0 0.0 60.0 40.0")
        self.assertAlignment(.topRight, "1: 40.0 0.0 60.0 40.0")
        self.assertAlignment(.left, "1: 0.0 30.0 60.0 40.0")
        self.assertAlignment(.right, "1: 40.0 30.0 60.0 40.0")
        self.assertAlignment(.bottomLeft, "1: 0.0 60.0 60.0 40.0")
        self.assertAlignment(.bottom, "1: 20.0 60.0 60.0 40.0")
        self.assertAlignment(.bottomRight, "1: 40.0 60.0 60.0 40.0")
    }
    
    // MARK: - Edge Cases
    
    func testFixedWidthAndHeightLargerThanContainer() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(width: 150, height: 120),
            expectedLayout: """
            1: -25.0 -10.0 150.0 120.0
            """
        )
    }
    
    func testFixedWidthAndHeightWithZeroDimensions() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(width: 0, height: 0),
            expectedLayout: """
            1: 50.0 50.0 0.0 0.0
            """
        )
    }
    
    // MARK: - Nested FixedFrame Tests
    
    func testNestedFixedFrames() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 80, height: 60)
                .frame(width: 50, height: 40),
            expectedLayout: """
            1: 10.0 20.0 80.0 60.0
            """
        )
    }
    
    func testNestedFixedFramesWithAlignment() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(width: 100, height: 100, alignment: .topLeft)
                .frame(width: 200, height: 200, alignment: .bottomRight),
            expectedLayout: """
            1: 50.0 50.0 60.0 40.0
            """
        )
    }
}
