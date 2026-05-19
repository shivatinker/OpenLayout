//
//  FixedSizeTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class FixedSizeTests: XCTestCase {
    func testFixedSizeBoth() {
        LayoutTest { Rect(1).fixedSize() }
            .checkLayout([1: CGRect(x: 45, y: 45, width: 10, height: 10)])
    }

    func testFixedSizeHorizontalOnly() {
        LayoutTest { Rect(1).fixedSize(horizontal: true, vertical: false) }
            .checkLayout([1: CGRect(x: 45, y: 0, width: 10, height: 100)])
    }

    func testFixedSizeVerticalOnly() {
        LayoutTest { Rect(1).fixedSize(horizontal: false, vertical: true) }
            .checkLayout([1: CGRect(x: 0, y: 45, width: 100, height: 10)])
    }

    func testFixedSizeNone() {
        LayoutTest { Rect(1).fixedSize(horizontal: false, vertical: false) }
            .checkLayout([1: CGRect(x: 0, y: 0, width: 100, height: 100)])
    }

    func testFixedSizeWithPadding() {
        LayoutTest { Rect(1).fixedSize().padding(10) }
            .checkLayout([1: CGRect(x: 45, y: 45, width: 10, height: 10)])
    }

    func testPaddingWithFixedSize() {
        LayoutTest { Rect(1).padding(10).fixedSize() }
            .checkLayout([1: CGRect(x: 45, y: 45, width: 10, height: 10)])
    }

    func testFixedSizeWithFlexibleFrame() {
        LayoutTest {
            Rect(1).fixedSize().frame(minWidth: 20, minHeight: 30)
        }
        .checkLayout([1: CGRect(x: 45, y: 45, width: 10, height: 10)])
    }

    func testNestedFixedSize() {
        LayoutTest {
            Rect(1).fixedSize().fixedSize(horizontal: false, vertical: true)
        }
        .checkLayout([1: CGRect(x: 45, y: 45, width: 10, height: 10)])
    }
}
