//
//  BackgroundTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class BackgroundTests: XCTestCase {
    func testSimpleBackground() {
        LayoutTest {
            Rect(1).background(Rect(2))
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 100),
            2: CGRect(x: 0, y: 0, width: 100, height: 100),
        ])
    }

    func testBackgroundWithPadding() {
        LayoutTest {
            Rect(1).background(Rect(2).padding(10))
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 100),
            2: CGRect(x: 10, y: 10, width: 80, height: 80),
        ])
    }

    func testBackgroundWithFrame() {
        LayoutTest {
            Rect(1)
                .frame(width: 50, height: 30)
                .background(Rect(2))
        }
        .checkLayout([
            1: CGRect(x: 25, y: 35, width: 50, height: 30),
            2: CGRect(x: 25, y: 35, width: 50, height: 30),
        ])
    }

    func testBackgroundWithFlexibleFrame() {
        LayoutTest {
            Rect(1)
                .frame(minWidth: 50, maxWidth: 100, minHeight: 30, maxHeight: 60)
                .background(Rect(2))
        }
        .checkLayout([
            1: CGRect(x: 0, y: 20, width: 100, height: 60),
            2: CGRect(x: 0, y: 20, width: 100, height: 60),
        ])
    }

    func testBackgroundWithStack() {
        LayoutTest {
            HStack(alignment: .center, spacing: 10) {
                Rect(1)
                Rect(2)
            }
            .background(Rect(3))
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 45, height: 100),
            2: CGRect(x: 55, y: 0, width: 45, height: 100),
            3: CGRect(x: 0, y: 0, width: 100, height: 100),
        ])
    }

    func testComplexBackground() {
        LayoutTest {
            VStack(alignment: .center, spacing: 5) {
                Rect(1)
                Rect(2)
            }
            .background(
                HStack(alignment: .center, spacing: 3) {
                    Rect(3)
                    Rect(4)
                }
            )
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 47.5),
            2: CGRect(x: 0, y: 52.5, width: 100, height: 47.5),
            3: CGRect(x: 0, y: 0, width: 48.5, height: 100),
            4: CGRect(x: 51.5, y: 0, width: 48.5, height: 100),
        ])
    }

    func testNestedBackgrounds() {
        LayoutTest {
            Rect(1)
                .background(Rect(2))
                .background(Rect(3))
        }
        .checkLayout([
            1: CGRect(x: 0, y: 0, width: 100, height: 100),
            2: CGRect(x: 0, y: 0, width: 100, height: 100),
            3: CGRect(x: 0, y: 0, width: 100, height: 100),
        ])
    }

    func testBackgroundWithZeroSizeContent() {
        LayoutTest {
            Rect(1)
                .frame(width: 0, height: 0)
                .background(Rect(2))
        }
        .checkLayout([
            1: CGRect(x: 50, y: 50, width: 0, height: 0),
            2: CGRect(x: 50, y: 50, width: 0, height: 0),
        ])
    }

    func testBackgroundWithLargeContent() {
        LayoutTest {
            Rect(1)
                .frame(width: 200, height: 150)
                .background(Rect(2))
        }
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        .checkLayout([
            1: CGRect(x: 50, y: 25, width: 200, height: 150),
            2: CGRect(x: 50, y: 25, width: 200, height: 150),
        ])
    }
}
