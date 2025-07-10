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
        
        root.layout(at: anchorPoint, proposition: proposedSize, result: &result)
        
        return result
    }
}

struct EvaluatedItem {
    let node: LayoutNode
    let rect: CGRect
}

public struct EvaluatedLeaf {
    public let item: Any
    public let rect: CGRect
}

public struct EvaluatedLayout {
    private var result: [EvaluatedItem] = []
    
    init() {}
    
    mutating func add(node: LayoutNode, rect: CGRect) {
        self.result.append(EvaluatedItem(node: node, rect: rect))
    }
    
    public func collectLeafs() -> [EvaluatedLeaf] {
        self.result.compactMap { item in
            if let leafItem = item.node.leafItem {
                return EvaluatedLeaf(item: leafItem, rect: item.rect)
            }
            else {
                return nil
            }
        }
    }
}
