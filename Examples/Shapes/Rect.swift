//
//  Rect.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import CoreFoundation
import OpenLayout
import OpenLayoutDSL

struct RectLayout: LeafLayout {
    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        proposal.replacingUnspecifiedDimensions(by: CGSize(width: 10.0, height: 10.0))
    }
}

struct Rect: LayoutItem {
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: RectLayout(),
            data: self.id
        )
    }
}
