//
//  AttributeTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import XCTest

final class AttributeTests: XCTestCase {
    private struct IDAssertionLeaf: LayoutLeafItem {
        struct Layout: LeafLayout {
            func sizeThatFits(_ size: ProposedSize) -> CGSize {
                XCTAssert(NodeAttributes.current.value(for: IDNodeAttributeKey.self) == 1)
                
                return size.replacingUnspecifiedDimensions(
                    by: CGSize(
                        width: 10,
                        height: 10
                    )
                )
            }
        }
        
        var layout: Layout {
            Layout()
        }
    }
    
    func testAttributePropagation() {
        let root = VStack {
            HStack {
                IDAssertionLeaf()
            }
        }
        .id(1)
        
        let engine = LayoutEngine()
        
        _ = engine.evaluateLayout(
            in: CGRect(
                origin: .zero,
                size: CGSize(width: 100, height: 100)
            ),
            root: root.makeNode()
        )
    }
}
