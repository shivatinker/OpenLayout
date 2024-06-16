//
//  LeafLayout.swift
//
//
//  Created by Andrii Zinoviev on 13.06.2024.
//

import CoreGraphics

protocol LeafLayout: Layout {
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize
}

extension LeafLayout {
    func sizeThatFits(_ proposal: ProposedSize, children: [some LayoutElementSizeProvider]) -> CGSize {
        assert(children.isEmpty)
        
        return self.sizeThatFits(proposal)
    }
    
    func placeChildren(_ children: [some LayoutElement], in frame: CGRect) {
        assert(children.isEmpty)
    }
}

struct DefaultLeafLayout: LeafLayout {
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        proposal.replacingUnspecifiedDimensions(by: CGSize(width: 10, height: 10))
    }
}
