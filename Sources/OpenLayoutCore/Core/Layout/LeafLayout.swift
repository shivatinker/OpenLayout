//
//  LeafLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public protocol LeafLayout {
    func sizeThatFits(_ size: ProposedSize) -> CGSize
}

extension LeafLayout {
    func makeAdapter() -> some Layout {
        LeafLayoutAdapter(layout: self)
    }
}

private struct LeafLayoutAdapter: Layout {
    let layout: LeafLayout
   
    func sizeThatFits(_ proposition: ProposedSize, children: [some LayoutSizeProvider]) -> CGSize {
        assert(children.isEmpty)
        return self.layout.sizeThatFits(proposition)
    }
    
    func placeChildren(in rect: CGRect, children: inout [some LayoutElement]) {
        assert(children.isEmpty)
    }
}
