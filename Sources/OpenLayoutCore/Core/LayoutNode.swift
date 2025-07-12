//
//  LayoutNode.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

extension NodeAttributes {
    @TaskLocal
    public static var current = NodeAttributes()
}

private final class LayoutNodeCache {
    var sizeThatFits: [ProposedSize: CGSize] = [:]
}

public struct LayoutNode {
    private let layout: Layout
    private let children: [LayoutNode]
    
    public let leafItem: Any?
    private let attributes: NodeAttributes
    
    private let cache = LayoutNodeCache()
    
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
    
    private func sizeThatFits(
        _ proposal: ProposedSize
    ) -> CGSize {
        self.mergingAttributes {
            if let cachedSize = self.cache.sizeThatFits[proposal] {
                return cachedSize
            }
            else {
                let size = self.layout.sizeThatFits(
                    proposal,
                    children: self.children.map { child in
                        SizeProviderAdapter(node: child)
                    }
                )
                
                self.cache.sizeThatFits[proposal] = size
                return size
            }
        }
    }
    
    func layout(
        at point: AnchorPoint,
        proposition: ProposedSize,
        visitor: (EvaluatedItem) -> Void
    ) {
        self.mergingAttributes {
            let selfSize = self.sizeThatFits(proposition)
            let selfRect = CGRect(anchorPoint: point, size: selfSize)
            
            visitor(
                EvaluatedItem(
                    node: self,
                    attributes: NodeAttributes.current,
                    rect: selfRect
                )
            )
            
            var childrenElements = self.children.map {
                ChildElement(node: $0, rect: nil)
            }
            
            self.layout.placeChildren(in: selfRect, children: &childrenElements)
            
            for child in childrenElements {
                if let rect = child.rect {
                    child.node.layout(
                        at: AnchorPoint(point: rect.center, alignment: .center),
                        proposition: ProposedSize(rect.size),
                        visitor: visitor
                    )
                }
            }
        }
    }
    
    private func mergingAttributes<T>(_ body: () -> T) -> T {
        let childAttributes = NodeAttributes.current.merge(with: self.attributes)
        
        return NodeAttributes.$current.withValue(childAttributes) {
            body()
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
