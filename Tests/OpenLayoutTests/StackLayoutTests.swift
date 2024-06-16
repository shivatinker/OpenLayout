@testable import OpenLayout
import XCTest

final class StackLayoutTests: LayoutTestCase {
    func testSimpleHVStack() {
        self.expectLayout(
            of: HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Rectangle().tagged(1)
                    Rectangle().tagged(2)
                }
                .tagged(6)
            
                VStack(spacing: 0) {
                    Rectangle().tagged(3)
                    Rectangle().tagged(4)
                    Rectangle().tagged(5)
                }
            },
            """
            1: (0.0, 0.0, 60.0, 60.0)
            2: (0.0, 60.0, 60.0, 60.0)
            3: (60.0, 0.0, 60.0, 40.0)
            4: (60.0, 40.0, 60.0, 40.0)
            5: (60.0, 80.0, 60.0, 40.0)
            6: (0.0, 0.0, 60.0, 120.0)
            """
        )
    }
    
    func testSpacingHVStack() {
        self.expectLayout(
            of: HStack(spacing: 10) {
                VStack(spacing: 10) {
                    Rectangle().tagged(1)
                    Rectangle().tagged(2)
                }
            
                VStack(spacing: 10) {
                    Rectangle().tagged(3)
                    Rectangle().tagged(4)
                    Rectangle().tagged(5)
                }
            },
            size: CGSize(width: 110, height: 110),
            """
            1: (0.0, 0.0, 50.0, 50.0)
            2: (0.0, 60.0, 50.0, 50.0)
            3: (60.0, 0.0, 50.0, 30.0)
            4: (60.0, 40.0, 50.0, 30.0)
            5: (60.0, 80.0, 50.0, 30.0)
            """
        )
    }
    
    func testEqualDistribution() {
        self.expectLayout(
            of:
            HStack(spacing: 0) {
                Rectangle().tagged(1)
                Rectangle().tagged(2)
                Rectangle().tagged(2)
            },
            """
            1: (0.0, 0.0, 40.0, 120.0)
            2: (40.0, 0.0, 40.0, 120.0)
            2: (80.0, 0.0, 40.0, 120.0)
            """
        )
    }
    
    func testStackSpacing() {
        self.expectLayout(
            of: HStack(spacing: 10) {
                Rectangle().tagged(1)
                Rectangle().tagged(2)
                Rectangle().tagged(3)
            },
            size: CGSize(width: 110, height: 100),
            """
            1: (0.0, 0.0, 30.0, 100.0)
            2: (40.0, 0.0, 30.0, 100.0)
            3: (80.0, 0.0, 30.0, 100.0)
            """
        )
    }
    
    func testOverflowSpacing() {
        self.expectOverflow {
            self.expectLayout(
                of: HStack(spacing: 100) {
                    Rectangle().tagged(1)
                    Rectangle().tagged(2)
                    Rectangle().tagged(3)
                },
                size: CGSize(width: 110, height: 100),
                """
                1: (-45.0, 0.0, 0.0, 100.0)
                2: (55.0, 0.0, 0.0, 100.0)
                3: (155.0, 0.0, 0.0, 100.0)
                """
            )
        }
    }
    
    func testDefaultSpacing() {
        self.expectLayout(
            of: HStack {
                Rectangle().tagged(1)
                Rectangle().tagged(2)
                Rectangle().tagged(3)
            },
            size: CGSize(width: 46, height: 100),
            """
            1: (0.0, 0.0, 10.0, 100.0)
            2: (18.0, 0.0, 10.0, 100.0)
            3: (36.0, 0.0, 10.0, 100.0)
            """
        )
    }
}
