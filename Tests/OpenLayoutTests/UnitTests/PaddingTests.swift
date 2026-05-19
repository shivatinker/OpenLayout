//
//  PaddingTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class PaddingTests: XCTestCase {
    // MARK: - Basic padding

    func testPaddingAll() {
        LayoutTest { Rect(1).padding(20) }
            .checkLayout([1: CGRect(x: 20, y: 20, width: 60, height: 60)])
    }

    func testPaddingHorizontal() {
        LayoutTest { Rect(1).padding(.horizontal, 15) }
            .checkLayout([1: CGRect(x: 15, y: 0, width: 70, height: 100)])
    }

    func testPaddingVertical() {
        LayoutTest { Rect(1).padding(.vertical, 25) }
            .checkLayout([1: CGRect(x: 0, y: 25, width: 100, height: 50)])
    }

    // MARK: - Individual edges

    func testPaddingTop() {
        LayoutTest { Rect(1).padding(.top, 30) }
            .checkLayout([1: CGRect(x: 0, y: 30, width: 100, height: 70)])
    }

    func testPaddingLeft() {
        LayoutTest { Rect(1).padding(.left, 40) }
            .checkLayout([1: CGRect(x: 40, y: 0, width: 60, height: 100)])
    }

    func testPaddingRight() {
        LayoutTest { Rect(1).padding(.right, 35) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 65, height: 100)])
    }

    func testPaddingBottom() {
        LayoutTest { Rect(1).padding(.bottom, 45) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 55)])
    }

    // MARK: - Multiple edges

    func testPaddingTopLeft() {
        LayoutTest { Rect(1).padding([.top, .left], 20) }
            .checkLayout([1: CGRect(x: 20, y: 20, width: 80, height: 80)])
    }

    func testPaddingTopRight() {
        LayoutTest { Rect(1).padding([.top, .right], 15) }
            .checkLayout([1: CGRect(x: 0, y: 15, width: 85, height: 85)])
    }

    func testPaddingBottomLeft() {
        LayoutTest { Rect(1).padding([.bottom, .left], 25) }
            .checkLayout([1: CGRect(x: 25, y: 0, width: 75, height: 75)])
    }

    func testPaddingBottomRight() {
        LayoutTest { Rect(1).padding([.bottom, .right], 10) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 90, height: 90)])
    }

    func testPaddingTopBottom() {
        LayoutTest { Rect(1).padding([.top, .bottom], 20) }
            .checkLayout([1: CGRect(x: 0, y: 20, width: 100, height: 60)])
    }

    func testPaddingLeftRight() {
        LayoutTest { Rect(1).padding([.left, .right], 30) }
            .checkLayout([1: CGRect(x: 30, y: 0, width: 40, height: 100)])
    }

    // MARK: - Three edges

    func testPaddingTopLeftRight() {
        LayoutTest { Rect(1).padding([.top, .left, .right], 15) }
            .checkLayout([1: CGRect(x: 15, y: 15, width: 70, height: 85)])
    }

    func testPaddingTopLeftBottom() {
        LayoutTest { Rect(1).padding([.top, .left, .bottom], 20) }
            .checkLayout([1: CGRect(x: 20, y: 20, width: 80, height: 60)])
    }

    func testPaddingTopRightBottom() {
        LayoutTest { Rect(1).padding([.top, .right, .bottom], 25) }
            .checkLayout([1: CGRect(x: 0, y: 25, width: 75, height: 50)])
    }

    func testPaddingLeftRightBottom() {
        LayoutTest { Rect(1).padding([.left, .right, .bottom], 10) }
            .checkLayout([1: CGRect(x: 10, y: 0, width: 80, height: 90)])
    }

    // MARK: - Edge cases

    func testZeroPadding() {
        LayoutTest { Rect(1).padding(0) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testLargePadding() {
        LayoutTest { Rect(1).padding(60) }
            .checkLayout([1: CGRect(x: 50, y: 50, width: 0, height: 0)])
    }

    // MARK: - Nested padding

    func testNestedPadding() {
        LayoutTest { Rect(1).padding(10).padding(5) }
            .checkLayout([1: CGRect(x: 15, y: 15, width: 70, height: 70)])
    }

    func testNestedPaddingDifferentEdges() {
        LayoutTest {
            Rect(1)
                .padding(.top, 15)
                .padding(.left, 25)
        }
        .checkLayout([1: CGRect(x: 25, y: 15, width: 75, height: 85)])
    }

    func testNestedPaddingMixed() {
        LayoutTest {
            Rect(1)
                .padding(20)
                .padding(.horizontal, 10)
        }
        .checkLayout([1: CGRect(x: 30, y: 20, width: 40, height: 60)])
    }

    // MARK: - With frame

    func testPaddingWithFixedChild() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .padding(10)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testPaddingWithFixedChildHorizontal() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .padding(.horizontal, 15)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testPaddingWithFixedChildVertical() {
        LayoutTest {
            Rect(1)
                .frame(width: 60, height: 40)
                .padding(.vertical, 20)
        }
        .checkLayout([1: CGRect(x: 20, y: 30, width: 60, height: 40)])
    }

    func testPaddingWithFrameConstraints() {
        LayoutTest {
            Rect(1)
                .frame(minWidth: 50, maxWidth: 80, minHeight: 30, maxHeight: 70)
                .padding(15)
        }
        .checkLayout([1: CGRect(x: 15, y: 15, width: 70, height: 70)])
    }
}
