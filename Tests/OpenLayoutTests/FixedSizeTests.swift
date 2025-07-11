import OpenLayout
import XCTest

@MainActor
final class FixedSizeTests: XCTestCase {
    func testFixedSizeBoth() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize(),
            expectedLayout: "1: 45.0 45.0 10.0 10.0"
        )
    }
    
    func testFixedSizeHorizontalOnly() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize(horizontal: true, vertical: false),
            expectedLayout: "1: 45.0 0.0 10.0 100.0"
        )
    }
    
    func testFixedSizeVerticalOnly() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize(horizontal: false, vertical: true),
            expectedLayout: "1: 0.0 45.0 100.0 10.0"
        )
    }
    
    func testFixedSizeNone() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize(horizontal: false, vertical: false),
            expectedLayout: "1: 0.0 0.0 100.0 100.0"
        )
    }
    
    func testFixedSizeWithPadding() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize().padding(10),
            expectedLayout: "1: 45.0 45.0 10.0 10.0"
        )
    }
    
    func testPaddingWithFixedSize() {
        Utils.assertLeafLayout(
            Rectangle().id(1).padding(10).fixedSize(),
            expectedLayout: "1: 45.0 45.0 10.0 10.0"
        )
    }
    
    func testFixedSizeWithFrame() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize().frame(minWidth: 20, minHeight: 30),
            expectedLayout: "1: 45.0 45.0 10.0 10.0"
        )
    }
    
    func testNestedFixedSize() {
        Utils.assertLeafLayout(
            Rectangle().id(1).fixedSize().fixedSize(horizontal: false, vertical: true),
            expectedLayout: "1: 45.0 45.0 10.0 10.0"
        )
    }
}
