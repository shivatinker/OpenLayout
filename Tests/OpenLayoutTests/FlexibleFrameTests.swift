import OpenLayout
import XCTest

@MainActor
final class FlexibleFrameTests: XCTestCase {
    // MARK: - Basic min/max/ideal tests

    func testMinWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minWidth: 80),
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }

    func testMaxWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(maxWidth: 5),
            expectedLayout: "1: 47.5 0.0 5.0 100.0"
        )
    }

    func testIdealWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(idealWidth: 30),
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }

    func testMinHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minHeight: 80),
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }

    func testMaxHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(maxHeight: 5),
            expectedLayout: "1: 0.0 47.5 100.0 5.0"
        )
    }

    func testIdealHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(idealHeight: 30),
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }

    // MARK: - Combined constraints

    func testMinMaxWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minWidth: 40, maxWidth: 60),
            expectedLayout: "1: 20.0 0.0 60.0 100.0"
        )
    }

    func testMinMaxHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minHeight: 40, maxHeight: 60),
            expectedLayout: "1: 0.0 20.0 100.0 60.0"
        )
    }

    func testAllConstraints() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(
                minWidth: 30, maxWidth: 70, idealWidth: 50,
                minHeight: 20, maxHeight: 80, idealHeight: 60
            ),
            expectedLayout: "1: 15.0 10.0 70.0 80.0"
        )
    }

    // MARK: - Alignment

    private func assertAlignment(_ alignment: Alignment, _ expected: String) {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(maxWidth: 60, maxHeight: 40)
                .frame(minWidth: 100, minHeight: 100, alignment: alignment),
            expectedLayout: expected
        )
    }

    func testAlignment() {
        self.assertAlignment(.center, "1: 20.0 30.0 60.0 40.0")
        self.assertAlignment(.topLeft, "1: 0.0 0.0 60.0 40.0")
        self.assertAlignment(.top, "1: 20.0 0.0 60.0 40.0")
        self.assertAlignment(.topRight, "1: 40.0 0.0 60.0 40.0")
        self.assertAlignment(.left, "1: 0.0 30.0 60.0 40.0")
        self.assertAlignment(.right, "1: 40.0 30.0 60.0 40.0")
        self.assertAlignment(.bottomLeft, "1: 0.0 60.0 60.0 40.0")
        self.assertAlignment(.bottom, "1: 20.0 60.0 60.0 40.0")
        self.assertAlignment(.bottomRight, "1: 40.0 60.0 60.0 40.0")
    }

    // MARK: - Edge cases

    func testMinGreaterThanMax() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minWidth: 80, maxWidth: 40),
            expectedLayout: "1: 30.0 0.0 40.0 100.0"
        )
    }

    func testZeroSize() {
        Utils.assertLeafLayout(
            Rectangle().id(1).frame(minWidth: 0, maxWidth: 0, minHeight: 0, maxHeight: 0),
            expectedLayout: "1: 50.0 50.0 0.0 0.0"
        )
    }

    // MARK: - Fixed-size child tests (general children)

    func testFlexibleFrameClampsFixedChildMinWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(minWidth: 80),
            expectedLayout: "1: 20.0 30.0 60.0 40.0"
        )
    }

    func testFlexibleFrameClampsFixedChildMaxWidth() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(maxWidth: 50),
            expectedLayout: "1: 20.0 30.0 60.0 40.0"
        )
    }

    func testFlexibleFrameClampsFixedChildMinHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(minHeight: 80),
            expectedLayout: "1: 20.0 30.0 60.0 40.0"
        )
    }

    func testFlexibleFrameClampsFixedChildMaxHeight() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(maxHeight: 30),
            expectedLayout: "1: 20.0 30.0 60.0 40.0"
        )
    }

    func testFlexibleFrameClampsFixedChildAll() {
        Utils.assertLeafLayout(
            Rectangle().id(1)
                .frame(width: 60, height: 40)
                .frame(minWidth: 30, maxWidth: 50, minHeight: 20, maxHeight: 30),
            expectedLayout: "1: 20.0 30.0 60.0 40.0"
        )
    }
}
