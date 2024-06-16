//
//  FrameLayoutTests.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

final class FrameLayoutTests: LayoutTestCase {
    private let canvasSize = CGSize(width: 100, height: 100)
    
    func testFrameAlignment() {
        self.testFrameAlignment(.bottom, "(45.0, 90.0, 10.0, 10.0)")
        self.testFrameAlignment(.bottomLeft, "(0.0, 90.0, 10.0, 10.0)")
        self.testFrameAlignment(.bottomRight, "(90.0, 90.0, 10.0, 10.0)")
        self.testFrameAlignment(.center, "(45.0, 45.0, 10.0, 10.0)")
        self.testFrameAlignment(.left, "(0.0, 45.0, 10.0, 10.0)")
        self.testFrameAlignment(.right, "(90.0, 45.0, 10.0, 10.0)")
        self.testFrameAlignment(.top, "(45.0, 0.0, 10.0, 10.0)")
        self.testFrameAlignment(.topLeft, "(0.0, 0.0, 10.0, 10.0)")
        self.testFrameAlignment(.topRight, "(90.0, 0.0, 10.0, 10.0)")
    }
    
    private func testFrameAlignment(
        _ alignment: Alignment,
        _ expectedRect: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        self.expectLayout(
            of: Rectangle()
                .tagged(1)
                .frame(width: 10, height: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                .tagged(2),
            size: self.canvasSize,
            """
            1: \(expectedRect)
            2: (0.0, 0.0, 100.0, 100.0)
            """,
            file: file,
            line: line
        )
    }
    
    func testSingleDimensionFixedFrame() {
        self.expectLayout(
            of: Rectangle().tagged(1).frame(width: 20).frame(maxWidth: .infinity, maxHeight: .infinity),
            size: self.canvasSize,
            "1: (40.0, 0.0, 20.0, 100.0)"
        )
        
        self.expectLayout(
            of: Rectangle().tagged(1).frame(height: 20).frame(maxWidth: .infinity, maxHeight: .infinity),
            size: self.canvasSize,
            "1: (0.0, 40.0, 100.0, 20.0)"
        )
    }
    
    func testIdealSize() {
        self.expectIdealSize(
            of: Rectangle().frame(idealWidth: 20),
            CGSize(width: 20, height: 10)
        )
        
        self.expectIdealSize(
            of: Rectangle().frame(idealHeight: 30),
            CGSize(width: 10, height: 30)
        )
        
        self.expectIdealSize(
            of: Rectangle().frame(idealWidth: 20, idealHeight: 30),
            CGSize(width: 20, height: 30)
        )
    }
}
