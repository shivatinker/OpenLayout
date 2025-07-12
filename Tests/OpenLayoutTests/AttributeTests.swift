//
//  AttributeTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import OpenLayoutText
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
        
        engine.layout(
            in: CGRect(
                origin: .zero,
                size: CGSize(width: 100, height: 100)
            ),
            root: root.makeNode(),
            visitor: { _ in }
        )
    }
    
    func testFontAttributePropagationInVStack() {
        let smallFont = Font(name: "Arial", size: 10)
        let largeFont = Font(name: "Arial", size: 20)
        
        let root = VStack {
            Text("A").id(1).font(smallFont)
            Text("B").id(2).font(largeFont)
        }
        
        let engine = LayoutEngine()
        var fonts: [Int: Font] = [:]
        
        engine.layout(
            in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            root: root.makeNode(),
            visitor: { item in
                let id = item.attributes.value(for: IDNodeAttributeKey.self)
                if let id {
                    fonts[id] = item.attributes.font
                }
            }
        )
        
        XCTAssertEqual(fonts[1], smallFont)
        XCTAssertEqual(fonts[2], largeFont)
    }
    
    func testFontAttributeDuringSizeThatFits() {
        let smallFont = Font(name: "Arial", size: 10)
        let largeFont = Font(name: "Arial", size: 20)
        
        // Create a custom leaf layout that checks NodeAttributes.current.font
        struct FontCheckingLeaf: LayoutLeafItem {
            let expectedFont: Font
            let id: Int
            
            struct Layout: LeafLayout {
                let expectedFont: Font
                let id: Int
                
                func sizeThatFits(_ size: ProposedSize) -> CGSize {
                    let currentFont = NodeAttributes.current.font
                    print("Node \(self.id): expected font \(self.expectedFont), current font \(currentFont)")
                    print("NodeAttributes.current: \(NodeAttributes.current)")
                    
                    // This will fail if the font is not set correctly
                    XCTAssertEqual(currentFont, self.expectedFont, "Font not set correctly for node \(self.id)")
                    
                    return CGSize(width: 50, height: 20)
                }
            }
            
            var layout: Layout {
                Layout(expectedFont: self.expectedFont, id: self.id)
            }
        }
        
        let root = VStack {
            FontCheckingLeaf(expectedFont: smallFont, id: 1).id(1).font(smallFont)
            FontCheckingLeaf(expectedFont: largeFont, id: 2).id(2).font(largeFont)
        }
        
        let engine = LayoutEngine()
        
        engine.layout(
            in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            root: root.makeNode(),
            visitor: { _ in }
        )
    }
}
