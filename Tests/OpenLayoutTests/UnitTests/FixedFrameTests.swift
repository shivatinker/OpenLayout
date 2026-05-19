//
//  FixedFrameTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class FixedFrameTests: XCTestCase {
    // MARK: - Width / height only

    func testFixedWidthOnly() {
        LayoutTest { Rect(1).frame(width: 50) }
            .checkLayout([1: CGRect(x: 25, y: 0, width: 50, height: 100)])
    }

    func testFixedHeightOnly() {
        LayoutTest { Rect(1).frame(height: 30) }
            .checkLayout([1: CGRect(x: 0, y: 35, width: 100, height: 30)])
    }

    func testFixedWidthAndHeight() {
        LayoutTest { Rect(1).frame(width: 60, height: 40) }
            .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    // MARK: - Alignment with nested frames

    private func checkWidthAlignment(
        _ alignment: Alignment,
        _ expected: CGRect,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        LayoutTest {
            Rect(1)
                .frame(width: 50)
                .frame(width: 100, height: 100, alignment: alignment)
        }
        .checkLayout([1: expected], file: file, line: line)
    }

    private func checkHeightAlignment(
        _ alignment: Alignment,
        _ expected: CGRect,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        LayoutTest {
            Rect(1)
                .frame(height: 30)
                .frame(width: 100, height: 100, alignment: alignment)
        }
        .checkLayout([1: expected], file: file, line: line)
    }

    func testWidthOnlyWithAlignments() {
        self.checkWidthAlignment(.center, CGRect(x: 25, y: 0, width: 50, height: 100))
        self.checkWidthAlignment(.left, CGRect(x: 0, y: 0, width: 50, height: 100))
        self.checkWidthAlignment(.right, CGRect(x: 50, y: 0, width: 50, height: 100))
    }

    func testHeightOnlyWithAlignments() {
        self.checkHeightAlignment(.center, CGRect(x: 0, y: 35, width: 100, height: 30))
        self.checkHeightAlignment(.top, CGRect(x: 0, y: 0, width: 100, height: 30))
        self.checkHeightAlignment(.bottom, CGRect(x: 0, y: 70, width: 100, height: 30))
    }

    // MARK: - All 9 alignments with width+height

    private func checkAlignment(
        _ alignment: Alignment,
        _ expected: CGRect,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(width: 100, height: 100, alignment: alignment)
        }
        .checkLayout([1: expected], file: file, line: line)
    }

    func testFixedWidthAndHeightWithAlignments() {
        self.checkAlignment(.center, CGRect(x: 20, y: 30, width: 60, height: 40))
        self.checkAlignment(.topLeft, CGRect(x: 0, y: 0, width: 60, height: 40))
        self.checkAlignment(.top, CGRect(x: 20, y: 0, width: 60, height: 40))
        self.checkAlignment(.topRight, CGRect(x: 40, y: 0, width: 60, height: 40))
        self.checkAlignment(.left, CGRect(x: 0, y: 30, width: 60, height: 40))
        self.checkAlignment(.right, CGRect(x: 40, y: 30, width: 60, height: 40))
        self.checkAlignment(.bottomLeft, CGRect(x: 0, y: 60, width: 60, height: 40))
        self.checkAlignment(.bottom, CGRect(x: 20, y: 60, width: 60, height: 40))
        self.checkAlignment(.bottomRight, CGRect(x: 40, y: 60, width: 60, height: 40))
    }

    // MARK: - Edge cases

    func testFixedWidthAndHeightLargerThanContainer() {
        LayoutTest { Rect(1).frame(width: 150, height: 120) }
            .checkLayout([1: CGRect(x: -25, y: -10, width: 150, height: 120)])
    }

    func testFixedWidthAndHeightZero() {
        LayoutTest { Rect(1).frame(width: 0, height: 0) }
            .checkLayout([1: CGRect(x: 50, y: 50, width: 0, height: 0)])
    }

    // MARK: - Nested fixed frames

    func testNestedFixedFrames() {
        LayoutTest {
            Rect(1)
                .frame(width: 80, height: 60)
                .frame(width: 50, height: 40)
        }
        .checkLayout([1: CGRect(x: 10, y: 20, width: 80, height: 60)])
    }

    func testNestedFixedFramesWithAlignment() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(width: 100, height: 100, alignment: .topLeft)
                .frame(width: 200, height: 200, alignment: .bottomRight)
        }
        .checkLayout([1: CGRect(x: 50, y: 50, width: 60, height: 40)])
    }
}
