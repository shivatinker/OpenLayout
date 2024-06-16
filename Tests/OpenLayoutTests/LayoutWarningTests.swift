//
//  LayoutWarningTests.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

final class LayoutWarningTests: LayoutTestCase {
    func testInvalidFrame() {
        self.expectInvalidFrame {
            self.expectLayout(
                of: Rectangle()
                    .frame(width: .infinity, height: .nan)
                    .tagged(1),
                """
                1: (-inf, nan, inf, nan)
                """
            )
        }
    }
    
    func testOverflow() {
        self.expectOverflow {
            self.expectLayout(
                of: Rectangle()
                    .frame(width: 1000, height: 1000)
                    .tagged(1),
                size: CGSize(width: 100, height: 100),
                """
                1: (-450.0, -450.0, 1000.0, 1000.0)
                """
            )
        }
    }
}
