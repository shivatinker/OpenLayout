//
//  FlexibleFrameTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class FlexibleFrameTests: XCTestCase {
    // MARK: - Basic min/max

    func testMinWidth() {
        LayoutTest { Rect(1).frame(minWidth: 80) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testMaxWidth() {
        LayoutTest { Rect(1).frame(maxWidth: 5) }
            .checkLayout([1: CGRect(x: 47.5, y: 0, width: 5, height: 100)])
    }

    func testMinHeight() {
        LayoutTest { Rect(1).frame(minHeight: 80) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testMaxHeight() {
        LayoutTest { Rect(1).frame(maxHeight: 5) }
            .checkLayout([1: CGRect(x: 0, y: 47.5, width: 100, height: 5)])
    }

    // MARK: - Combined constraints

    func testMinMaxWidth() {
        LayoutTest { Rect(1).frame(minWidth: 40, maxWidth: 60) }
            .checkLayout([1: CGRect(x: 20, y: 0, width: 60, height: 100)])
    }

    func testMinMaxHeight() {
        LayoutTest { Rect(1).frame(minHeight: 40, maxHeight: 60) }
            .checkLayout([1: CGRect(x: 0, y: 20, width: 100, height: 60)])
    }

    func testAllConstraints() {
        LayoutTest {
            Rect(1).frame(minWidth: 30, maxWidth: 70, minHeight: 20, maxHeight: 80)
        }
        .checkLayout([1: CGRect(x: 15, y: 10, width: 70, height: 80)])
    }

    // MARK: - Alignment

    private func checkAlignment(
        _ alignment: Alignment,
        _ expected: CGRect,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        LayoutTest {
            Rect(1)
                .frame(maxWidth: 60, maxHeight: 40)
                .frame(minWidth: 100, minHeight: 100, alignment: alignment)
        }
        .checkLayout([1: expected], file: file, line: line)
    }

    func testAlignment() {
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

    func testZeroSize() {
        LayoutTest {
            Rect(1).frame(minWidth: 0, maxWidth: 0, minHeight: 0, maxHeight: 0)
        }
        .checkLayout([1: CGRect(x: 50, y: 50, width: 0, height: 0)])
    }

    func testInfinityMaxWidth() {
        LayoutTest {
            Rect(1)
                .frame(width: 10, height: 10)
                .frame(maxWidth: .infinity, alignment: .right)
        }
        .checkLayout([1: CGRect(x: 90, y: 45, width: 10, height: 10)])
    }

    // MARK: - Fixed-size child with flexible frame

    func testFlexibleFrameClampsFixedChildMinWidth() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(minWidth: 80)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testFlexibleFrameClampsFixedChildMaxWidth() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(maxWidth: 50)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testFlexibleFrameClampsFixedChildMinHeight() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(minHeight: 80)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testFlexibleFrameClampsFixedChildMaxHeight() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(maxHeight: 30)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testFlexibleFrameClampsFixedChildAll() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .frame(minWidth: 30, maxWidth: 50, minHeight: 20, maxHeight: 30)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    // MARK: - HStack with flexible frame alignment

    func testHStackWithFlexibleFrameAlignment() {
        LayoutTest {
            HStack(spacing: 10) {
                Rect(1).frame(width: 20, height: 20)
                Rect(2).frame(width: 20, height: 20)
            }
            .frame(maxWidth: .infinity, alignment: .left)
        }
        .checkLayout([
            1: CGRect(x: 0, y: 40, width: 20, height: 20),
            2: CGRect(x: 30, y: 40, width: 20, height: 20),
        ])
    }
}
