//
//  Box.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

import CoreFoundation
import OpenLayout
import OpenLayoutDSL

public struct Box: LayoutItem {
    public init() {}
    
    public func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: Layout(),
            data: BoxDrawable(attributes: .default)
        )
    }
    
    private struct Layout: LeafLayout {
        func sizeThatFits(proposal: ProposedSize) -> CGSize {
            proposal.replacingUnspecifiedDimensions(by: CGSize(width: 2, height: 2))
        }
    }
}
