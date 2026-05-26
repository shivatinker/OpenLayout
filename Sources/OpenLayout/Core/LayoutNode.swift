//
//  LayoutNode.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 14.05.2026.
//

import CoreFoundation

public struct LayoutContext {
    public var layoutDirection: Axis?
    
    public init() {}
}

public final class LayoutNode: ChildPlacement, CustomStringConvertible {
    private let layout: any Layout
    public let children: [LayoutNode]
    public let leafData: Any?
    
    public private(set) var frame: CGRect?
    private var sizeThatFitsCache: [ProposedSize: CGSize] = [:]
    
    private init(
        context: LayoutContext,
        layout: any Layout,
        children: [LayoutNode],
        leafData: Any? = nil
    ) {
        self.layout = layout
        self.leafData = leafData
        self.children = children
    }

    public static func makeLeafNode(
        context: LayoutContext,
        layout: some LeafLayout,
        data: Any?
    ) -> LayoutNode {
        LayoutNode(context: context, layout: LeafLayoutAdapter(layout: layout), children: [], leafData: data)
    }

    public static func makeContainerNode(
        context: LayoutContext,
        layout: Layout,
        children: [LayoutNode]
    ) -> LayoutNode {
        LayoutNode(context: context, layout: layout, children: children)
    }

    public static func makeUnaryNode(
        context: LayoutContext,
        layout: some UnaryLayout,
        child: LayoutNode
    ) -> LayoutNode {
        LayoutNode(context: context, layout: UnaryLayoutAdapter(layout: layout), children: [child])
    }

    public func doLayout() {
        guard let frame else {
            preconditionFailure("layout: Frame is not set for node \(self)")
        }

        self.layout.placeChildren(self.children, bounds: frame)

        for child in self.children {
            if child.frame == nil {
                preconditionFailure("layout: Frame is not placed for child node \(child) of node \(self)")
            }
            
            child.doLayout()
        }
    }
    
    public func layoutPriority() -> Int {
        self.layout.layoutPriority()
    }
    
    public var description: String {
        "<LayoutNode \(self.children.count) children; \(self.layout)>"
    }
    
    // MARK: ChildMeasurement

    public func sizeThatFits(proposal: ProposedSize) -> CGSize {
        if let cachedSize = self.sizeThatFitsCache[proposal] {
            return cachedSize
        }
        
        let size = self.layout.sizeThatFits(self.children, proposal: proposal)
        self.sizeThatFitsCache[proposal] = size
        return size
    }
    
    // MARK: ChildPlacement

    public func place(frame: CGRect) {
        guard self.frame == nil else {
            preconditionFailure("place: Frame already set for node \(self)")
        }

        self.frame = frame
    }
}
