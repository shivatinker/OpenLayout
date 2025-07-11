//
//  LayoutNode.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct LayoutNode {
    private let layout: Layout
    private let children: [LayoutNode]
    
    public let leafItem: Any?
    private let attributes: NodeAttributes
    
    private struct SizeProviderAdapter: LayoutSizeProvider {
        let node: LayoutNode
        
        func sizeThatFits(_ size: ProposedSize) -> CGSize {
            self.node.sizeThatFits(size)
        }
    }
    
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
    
    private func sizeThatFits(_ size: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(
            size,
            children: self.children.map(SizeProviderAdapter.init(node:))
        )
    }
    
    func layout(
        at point: AnchorPoint,
        proposition: ProposedSize,
        attributes: NodeAttributes,
        result: inout EvaluatedLayout
    ) {
        let selfSize = self.sizeThatFits(proposition)
        let selfRect = CGRect(anchorPoint: point, size: selfSize)
        
        result.add(node: self, attributes: attributes, rect: selfRect)
        
        var childrenElements = self.children.map {
            ChildElement(node: $0, rect: nil)
        }
        
        self.layout.placeChildren(in: selfRect, children: &childrenElements)
        
        let childAttributes = attributes.merge(with: self.attributes)
        
        for child in childrenElements {
            if let rect = child.rect {
                child.node.layout(
                    at: AnchorPoint(point: rect.center, alignment: .center),
                    proposition: ProposedSize(rect.size),
                    attributes: childAttributes,
                    result: &result
                )
            }
        }
    }
    
    // MARK: Constructors
    
    private init(
        layout: Layout,
        children: [LayoutNode] = [],
        leafItem: Any? = nil,
        attributes: NodeAttributes = NodeAttributes()
    ) {
        self.layout = layout
        self.children = children
        self.leafItem = leafItem
        self.attributes = attributes
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
    
    public static func makeUnaryContainer(
        layout: some UnaryLayout,
        child: LayoutNode
    ) -> Self {
        self.init(
            layout: layout.makeAdapter(),
            children: [child]
        )
    }
    
    public static func makeAttributeNode(
        attributes: NodeAttributes,
        child: LayoutNode
    ) -> Self {
        self.init(
            layout: TransparentLayout().makeAdapter(),
            children: [child],
            attributes: attributes
        )
    }
}
