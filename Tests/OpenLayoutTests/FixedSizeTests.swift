//
//  FixedSizeTests.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

final class FixedSizeTests: LayoutTestCase {
    func testFixedSizeLayout() {
        self.expectLayout(
            of: Rectangle()
                .tagged(1)
                .frame(idealWidth: 20, idealHeight: 30)
                .fixedSize(),
            size: CGSize(width: 100, height: 100),
            """
            1: (40.0, 35.0, 20.0, 30.0)
            """
        )
    }
    
    func testFixedWidthLayout() {
        self.expectLayout(
            of: Rectangle()
                .tagged(1)
                .frame(idealWidth: 20, idealHeight: 30)
                .fixedSize(horizontal: true, vertical: false),
            size: CGSize(width: 100, height: 100),
            """
            1: (40.0, 0.0, 20.0, 100.0)
            """
        )
    }

    func testFixedHeightLayout() {
        self.expectLayout(
            of: Rectangle()
                .tagged(1)
                .frame(idealWidth: 20, idealHeight: 30)
                .fixedSize(horizontal: false, vertical: true),
            size: CGSize(width: 100, height: 100),
            """
            1: (0.0, 35.0, 100.0, 30.0)
            """
        )
    }
}
