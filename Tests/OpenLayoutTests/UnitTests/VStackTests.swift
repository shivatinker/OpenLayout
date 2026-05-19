//
//  VStackTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
import XCTest

final class VStackTests: XCTestCase {
    func testBasicVStack() {
        LayoutTest {
            VStack {
                Rect(1)
                Rect(2)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 46),
            2: CGRect(x: 0, y: 54, width: 100, height: 46),
        ])
    }

    func testVStackWithSpacing() {
        LayoutTest {
            VStack(spacing: 20) {
                Rect(1)
                Rect(2)
                Rect(3)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 20),
            2: CGRect(x: 0, y: 40, width: 100, height: 20),
            3: CGRect(x: 0, y: 80, width: 100, height: 20),
        ])
    }

    func testVStackWithFixedSizeChildren() {
        LayoutTest {
            VStack {
                Rect(1).frame(width: 30, height: 20)
                Rect(2).frame(width: 40, height: 30)
            }
        }
        .checkLayout([
            1: CGRect(x: 35, y: 21, width: 30, height: 20),
            2: CGRect(x: 30, y: 49, width: 40, height: 30),
        ])
    }

    func testVStackWithFlexibleFrame() {
        LayoutTest {
            VStack {
                Rect(1).frame(minHeight: 20, maxHeight: 40)
                Rect(2).frame(minHeight: 30, maxHeight: 50)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 1, width: 100, height: 40),
            2: CGRect(x: 0, y: 49, width: 100, height: 50),
        ])
    }

    func testVStackWithPadding() {
        LayoutTest {
            VStack {
                Rect(1).padding(10)
                Rect(2).padding(5)
            }
        }
        .checkLayout([
            1: CGRect(x: 10, y: 10, width: 80, height: 26),
            2: CGRect(x: 5, y: 59, width: 90, height: 36),
        ])
    }

    func testSingleChildVStack() {
        LayoutTest { VStack { Rect(1) } }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testEmptyVStack() {
        LayoutTest { VStack {} }
            .checkLayout([:])
    }

    // MARK: - Alignment

    func testVStackLeftAlignment() {
        LayoutTest {
            VStack(alignment: .left, spacing: 8) {
                Rect(1).frame(width: 30, height: 20)
                Rect(2).frame(width: 40, height: 25)
                Rect(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 30, y: 12, width: 30, height: 20),
            2: CGRect(x: 30, y: 40, width: 40, height: 25),
            3: CGRect(x: 30, y: 73, width: 25, height: 15),
        ])
    }

    func testVStackCenterAlignment() {
        LayoutTest {
            VStack(alignment: .center, spacing: 8) {
                Rect(1).frame(width: 30, height: 20)
                Rect(2).frame(width: 40, height: 25)
                Rect(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 35, y: 12, width: 30, height: 20),
            2: CGRect(x: 30, y: 40, width: 40, height: 25),
            3: CGRect(x: 37.5, y: 73, width: 25, height: 15),
        ])
    }

    func testVStackRightAlignment() {
        LayoutTest {
            VStack(alignment: .right, spacing: 8) {
                Rect(1).frame(width: 30, height: 20)
                Rect(2).frame(width: 40, height: 25)
                Rect(3).frame(width: 25, height: 15)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 40, y: 12, width: 30, height: 20),
            2: CGRect(x: 30, y: 40, width: 40, height: 25),
            3: CGRect(x: 45, y: 73, width: 25, height: 15),
        ])
    }

    func testVStackAlignmentWithSpacing() {
        LayoutTest {
            VStack(alignment: .center, spacing: 10) {
                Rect(1).frame(width: 25, height: 15)
                Rect(2).frame(width: 35, height: 20)
                Rect(3).frame(width: 20, height: 12)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 37.5, y: 16.5, width: 25, height: 15),
            2: CGRect(x: 32.5, y: 41.5, width: 35, height: 20),
            3: CGRect(x: 40, y: 71.5, width: 20, height: 12),
        ])
    }
}
