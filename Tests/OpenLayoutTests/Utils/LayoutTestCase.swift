//
//  LayoutTestCase.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

class LayoutTestCase: XCTestCase {
    override func run() {
        Configuration.withCustomWarningHandler({ XCTFail("Unexpected layout warning: \($0)") }) {
            super.run()
        }
    }
    
    func expectLayout(
        of view: some View,
        size: CGSize = CGSize(width: 120, height: 120),
        _ expectedLayout: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let node = view.frame(width: size.width, height: size.height).makeNode()
            
        node.place(
            at: .zero,
            anchor: .topLeft,
            proposal: ProposedSize(size: size)
        )
            
        XCTAssertEqual(node.dumpTags(), expectedLayout, file: file, line: line)
    }
    
    func expectInvalidFrame(
        file: StaticString = #file,
        line: UInt = #line,
        _ execute: () -> Void
    ) {
        self.expectLayoutWarning(execute, file: file, line: line) { warning in
            if case .invalidFrame = warning {
                true
            }
            else {
                false
            }
        }
    }
    
    func expectOverflow(
        file: StaticString = #file,
        line: UInt = #line,
        _ execute: () -> Void
    ) {
        self.expectLayoutWarning(execute, file: file, line: line) { warning in
            if case .overflow = warning {
                true
            }
            else {
                false
            }
        }
    }
    
    func expectLayoutWarning(
        _ execute: () -> Void,
        file: StaticString = #file,
        line: UInt = #line,
        checkWarning: (LayoutWarning) -> Bool
    ) {
        var didHandle = false
        
        let handler: (LayoutWarning) -> Void = { warning in
            if false == checkWarning(warning) {
                XCTFail("Unexpected layout warning: \(warning)", file: file, line: line)
            }
            else {
                didHandle = true
            }
        }
        
        Configuration.withCustomWarningHandler(handler) {
            execute()
        }
        
        XCTAssert(didHandle, "No warning was handled", file: file, line: line)
    }

    func expectIdealSize(
        of view: some View,
        _ expectedSize: CGSize,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let node = view.makeNode()
        XCTAssertEqual(node.idealSize(), expectedSize, file: file, line: line)
    }
}
