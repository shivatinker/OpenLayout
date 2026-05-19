//
//  LayoutTest.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import XCTest

final class LayoutTest {
    private let item: LayoutItem
    private var rect = CGRect(origin: .zero, size: CGSize(width: 100.0, height: 100.0))

    func setFrame(_ rect: CGRect) -> LayoutTest {
        self.rect = rect
        return self
    }
    
    init(_ item: () -> LayoutItem) {
        self.item = item()
    }
    
    func checkLayout(_ expectedFrames: [Int: CGRect], file: StaticString = #filePath, line: UInt = #line) {
        let context = LayoutContext()
        let node = self.item.makeLayoutNode(context: context)
        let size = node.sizeThatFits(proposal: ProposedSize(self.rect.size))
        node.place(frame: CGRect(point: self.rect.center, anchor: .center, size: size))
        node.doLayout()
        
        print(LayoutNodeDumper().dump(node))
        
        var rects: [RectDrawable] = []
        collectRects(from: node, into: &rects)

        print(rects)

        XCTAssertEqual(rects.count, expectedFrames.count)

        for rect in rects {
            guard let expectedFrame = expectedFrames[rect.id] else {
                XCTFail("No rect \(rect.id) in expectation")
                continue
            }

            let accuracy = 1e-5
            XCTAssertEqual(rect.frame.minX, expectedFrame.minX, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(rect.frame.minY, expectedFrame.minY, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(rect.frame.maxX, expectedFrame.maxX, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(rect.frame.maxY, expectedFrame.maxY, accuracy: accuracy, file: file, line: line)
        }
    }
}
