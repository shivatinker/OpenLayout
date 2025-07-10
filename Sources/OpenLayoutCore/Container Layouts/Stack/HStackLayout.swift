//
//  HStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct HStackLayout: Layout {
    private let engine: StackLayoutEngine
    
    public init(spacing: CGFloat = 8) {
        self.engine = StackLayoutEngine(spacing: spacing)
    }
    
    public func sizeThatFits(
        _ proposition: ProposedSize,
        children: [some LayoutSizeProvider]
    ) -> CGSize {
        self.engine.sizeThatFits(proposition, children: children)
    }
    
    public func placeChildren(
        in rect: CGRect,
        children: inout [some LayoutElement]
    ) {
        let childrenPlacements = self.engine.placeChildren(children, in: rect)
        
        for (index, placement) in childrenPlacements.enumerated() {
            children[index].place(
                at: placement.0,
                anchor: .topLeft,
                proposal: placement.1
            )
        }
    }
}
