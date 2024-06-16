//
//  HStack.swift
//
//
//  Created by Andrii Zinoviev on 13.06.2024.
//

import CoreGraphics

struct HStack: HVStack {
    private let engine: StackLayoutEngine
    
    init(spacing: CGFloat = Self.defaultSpacing) {
        self.engine = StackLayoutEngine(spacing: spacing)
    }
    
    func sizeThatFits(_ proposal: ProposedSize, children: [some LayoutElementSizeProvider]) -> CGSize {
        self.engine.sizeThatFits(proposal, children: children)
    }
    
    func placeChildren(_ children: [some LayoutElement], in frame: CGRect) {
        self.engine.placeChildren(children, in: frame)
    }
}
