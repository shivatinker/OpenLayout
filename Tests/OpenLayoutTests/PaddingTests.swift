//
//  PaddingTests.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

final class PaddingTests: LayoutTestCase {
    func testEqualPadding() {
        self.testPadding(
            [.bottom, .left, .right, .top],
            10,
            """
            1: (15.0, 15.0, 10.0, 10.0)
            2: (5.0, 5.0, 30.0, 30.0)
            """
        )
    }
    
    func testOneEdgePadding() {
        self.testPadding(
            [.bottom],
            10,
            """
            1: (15.0, 10.0, 10.0, 10.0)
            2: (15.0, 10.0, 10.0, 20.0)
            """
        )
        
        self.testPadding(
            [.left],
            10,
            """
            1: (20.0, 15.0, 10.0, 10.0)
            2: (10.0, 15.0, 20.0, 10.0)
            """
        )
        
        self.testPadding(
            [.right],
            10,
            """
            1: (10.0, 15.0, 10.0, 10.0)
            2: (10.0, 15.0, 20.0, 10.0)
            """
        )
        
        self.testPadding(
            [.top],
            10,
            """
            1: (15.0, 20.0, 10.0, 10.0)
            2: (15.0, 10.0, 10.0, 20.0)
            """
        )
    }
    
    func testOverflowPadding() {
        self.expectOverflow {
            self.testPadding(
                [.top, .bottom],
                100,
                """
                1: (15.0, 15.0, 10.0, 10.0)
                2: (15.0, -85.0, 10.0, 210.0)
                """
            )
        }
    }
    
    func testSquashingPadding() {
        self.expectOverflow {
            self.expectLayout(
                of: Rectangle()
                    .tagged(1)
                    .padding(.vertical, 30)
                    .tagged(2),
                size: CGSize(width: 50, height: 50),
                """
                1: (0.0, 25.0, 50.0, 0.0)
                2: (0.0, -5.0, 50.0, 60.0)
                """
            )
        }
        
        self.expectOverflow {
            self.expectLayout(
                of: Rectangle()
                    .tagged(1)
                    .padding(150)
                    .tagged(2),
                size: CGSize(width: 50, height: 50),
                """
                1: (25.0, 25.0, 0.0, 0.0)
                2: (-125.0, -125.0, 300.0, 300.0)
                """
            )
        }
    }
    
    func testPaddingIdealSize() {
        self.expectIdealSize(
            of: Rectangle()
                .frame(idealWidth: 20, idealHeight: 30)
                .padding(10),
            CGSize(width: 40, height: 50)
        )
        
        self.expectIdealSize(
            of: Rectangle()
                .frame(idealWidth: 20, idealHeight: 30)
                .padding(.bottom, 10),
            CGSize(width: 20, height: 40)
        )
    }
    
    func testCompositePadding() {
        self.expectLayout(
            of: Rectangle()
                .frame(width: 10, height: 10)
                .tagged(1)
                .padding(.top, 10)
                .padding(.bottom, 5)
                .padding(.left, 7)
                .padding(.right, 6)
                .tagged(2),
            size: CGSize(width: 100, height: 100),
            """
            1: (45.5, 47.5, 10.0, 10.0)
            2: (38.5, 37.5, 23.0, 25.0)
            """
        )
    }
    
    private func testPadding(
        _ edges: Edge.Set,
        _ padding: CGFloat,
        _ expectedLayout: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        self.expectLayout(
            of: Rectangle()
                .tagged(1)
                .frame(width: 10, height: 10)
                .padding(edges, padding)
                .tagged(2),
            size: CGSize(width: 40, height: 40),
            expectedLayout,
            file: file,
            line: line
        )
    }
}
