//
//  LayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct LayoutEngine {
    public init() {}
    
    public func layout(
        in rect: CGRect,
        root: LayoutNode,
        visitor: (EvaluatedItem) -> Void
    ) {
        let proposedSize = ProposedSize(rect.size)
        let anchorPoint = AnchorPoint(point: rect.center, alignment: .center)
        
        root.layout(
            at: anchorPoint,
            proposition: proposedSize,
            attributes: NodeAttributes(),
            visitor: visitor
        )
    }
}

public struct EvaluatedItem {
    public let node: LayoutNode
    
    // FIXME: Memory consumption
    public let attributes: NodeAttributes
    
    public let rect: CGRect
}
