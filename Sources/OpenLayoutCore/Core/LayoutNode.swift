//
//  LayoutNode.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct LayoutNode: LayoutSizeProvider {
    let layout: Layout
    let leafItem: Any?
    let children: [LayoutNode]
    
    private struct ChildElement: LayoutElement {
        let node: LayoutNode
        var rect: CGRect?
        
        func sizeThatFits(_ size: ProposedSize) -> CGSize {
            self.node.sizeThatFits(size)
        }
        
        mutating func place(at point: CGPoint, anchor: Alignment, proposal: ProposedSize) {
            let size = self.sizeThatFits(proposal)
            self.rect = CGRect(anchorPoint: AnchorPoint(point: point, alignment: anchor), size: size)
        }
    }
    
    public func sizeThatFits(_ size: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(size, children: self.children)
    }
    
    func layout(
        at point: AnchorPoint,
        proposition: ProposedSize,
        result: inout EvaluatedLayout
    ) {
        let selfSize = self.sizeThatFits(proposition)
        let selfRect = CGRect(anchorPoint: point, size: selfSize)
        
        result.add(node: self, rect: selfRect)
        
        var childrenElements = self.children.map {
            ChildElement(node: $0, rect: nil)
        }
        
        self.layout.placeChildren(in: selfRect, children: &childrenElements)
        
        for child in childrenElements {
            if let rect = child.rect {
                child.node.layout(
                    at: AnchorPoint(point: rect.center, alignment: .center),
                    proposition: ProposedSize(rect.size),
                    result: &result
                )
            }
        }
    }
    
    private init(
        layout: Layout,
        leafItem: Any? = nil,
        children: [LayoutNode] = []
    ) {
        self.layout = layout
        self.leafItem = leafItem
        self.children = children
    }
    
    public static func makeLeaf(
        layout: some LeafLayout,
        item: Any
    ) -> Self {
        self.init(
            layout: layout.makeAdapter(),
            leafItem: item
        )
    }
    
    public static func makeContainer(
        layout: some Layout,
        children: [LayoutNode]
    ) -> Self {
        self.init(
            layout: layout,
            children: children
        )
    }
}
