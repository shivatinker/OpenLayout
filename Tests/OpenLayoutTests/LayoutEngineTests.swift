//
//  LayoutEngineTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class LayoutEngineTests: XCTestCase {
    func testSimple() {
        LayoutTest {
            Rect(1)
                .padding(10)
                .padding(5)
        }
        .checkLayout([1: CGRect(x: 15, y: 15, width: 70, height: 70)])
    }
}
