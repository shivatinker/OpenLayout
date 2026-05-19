//
//  HStackTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
import XCTest

final class HStackTests: XCTestCase {
    func testBasicHStack() {
        LayoutTest {
            HStack {
                Rect(1)
                Rect(2)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 46, height: 100),
            2: CGRect(x: 54, y: 0, width: 46, height: 100),
        ])
    }

    func testHStackWithSpacing() {
        LayoutTest {
            HStack(spacing: 20) {
                Rect(1)
                Rect(2)
                Rect(3)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 20, height: 100),
            2: CGRect(x: 40, y: 0, width: 20, height: 100),
            3: CGRect(x: 80, y: 0, width: 20, height: 100),
        ])
    }

    func testHStackWithFixedSizeChildren() {
        LayoutTest {
            HStack {
                Rect(1).frame(width: 30, height: 20)
                Rect(2).frame(width: 40, height: 30)
            }
        }
        .checkLayout([
            1: CGRect(x: 11, y: 40, width: 30, height: 20),
            2: CGRect(x: 49, y: 35, width: 40, height: 30),
        ])
    }

    func testHStackWithFlexibleFrame() {
        LayoutTest {
            HStack {
                Rect(1).frame(minWidth: 20, maxWidth: 40)
                Rect(2).frame(minWidth: 30, maxWidth: 50)
            }
        }
        .checkLayout([
            1: CGRect(x: 1, y: 0, width: 40, height: 100),
            2: CGRect(x: 49, y: 0, width: 50, height: 100),
        ])
    }

    func testHStackWithPadding() {
        LayoutTest {
            HStack {
                Rect(1).padding(10)
                Rect(2).padding(5)
            }
        }
        .checkLayout([
            1: CGRect(x: 10, y: 10, width: 26, height: 80),
            2: CGRect(x: 59, y: 5, width: 36, height: 90),
        ])
    }

    func testSingleChildHStack() {
        LayoutTest {
            HStack { Rect(1) }
        }
        .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testEmptyHStack() {
        LayoutTest { HStack {} }
            .checkLayout([:])
    }

    // MARK: - Alignment

    func testHStackTopAlignment() {
        LayoutTest {
            HStack(alignment: .top, spacing: 8) {
                Rect(1).frame(width: 20, height: 30)
                Rect(2).frame(width: 30, height: 20)
                Rect(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 4.5, y: 30, width: 20, height: 30),
            2: CGRect(x: 32.5, y: 30, width: 30, height: 20),
            3: CGRect(x: 70.5, y: 30, width: 25, height: 40),
        ])
    }

    func testHStackCenterAlignment() {
        LayoutTest {
            HStack(alignment: .center, spacing: 8) {
                Rect(1).frame(width: 20, height: 30)
                Rect(2).frame(width: 30, height: 20)
                Rect(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 4.5, y: 35, width: 20, height: 30),
            2: CGRect(x: 32.5, y: 40, width: 30, height: 20),
            3: CGRect(x: 70.5, y: 30, width: 25, height: 40),
        ])
    }

    func testHStackBottomAlignment() {
        LayoutTest {
            HStack(alignment: .bottom, spacing: 8) {
                Rect(1).frame(width: 20, height: 30)
                Rect(2).frame(width: 30, height: 20)
                Rect(3).frame(width: 25, height: 40)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 4.5, y: 40, width: 20, height: 30),
            2: CGRect(x: 32.5, y: 50, width: 30, height: 20),
            3: CGRect(x: 70.5, y: 30, width: 25, height: 40),
        ])
    }

    func testHStackAlignmentWithSpacing() {
        LayoutTest {
            HStack(alignment: .center, spacing: 10) {
                Rect(1).frame(width: 15, height: 25)
                Rect(2).frame(width: 20, height: 15)
                Rect(3).frame(width: 18, height: 35)
            }
            .frame(width: 100, height: 100)
        }
        .checkLayout([
            1: CGRect(x: 13.5, y: 37.5, width: 15, height: 25),
            2: CGRect(x: 38.5, y: 42.5, width: 20, height: 15),
            3: CGRect(x: 68.5, y: 32.5, width: 18, height: 35),
        ])
    }

    // MARK: - Mixed (fixed + flexible)

    func testMixedHStack() {
        LayoutTest {
            HStack(spacing: 10) {
                Rect(1).frame(minWidth: 30, maxWidth: 100)
                Rect(2).frame(width: 10)
            }
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 80, height: 100),
            2: CGRect(x: 90, y: 0, width: 10, height: 100),
        ])
    }
}
