//
//  LayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct LayoutEngine {
    public init() {}
    
    public func evaluateLayout(
        in rect: CGRect,
        root: LayoutNode
    ) -> EvaluatedLayout {
        let proposedSize = ProposedSize(rect.size)
        
        var result = EvaluatedLayout()
        
        let anchorPoint = AnchorPoint(point: rect.center, alignment: .center)
        
        root.layout(
            at: anchorPoint,
            proposition: proposedSize,
            attributes: NodeAttributes(),
            result: &result
        )
        
        return result
    }
}

public struct EvaluatedItem {
    public let node: LayoutNode
    
    // FIXME: Memory consumption
    public let attributes: NodeAttributes
    
    public let rect: CGRect
}

public struct EvaluatedLayout {
    public private(set) var items: [EvaluatedItem] = []
    
    init() {}
    
    mutating func add(node: LayoutNode, attributes: NodeAttributes, rect: CGRect) {
        self.items.append(EvaluatedItem(node: node, attributes: attributes, rect: rect))
    }
}
