//
//  HStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct HStackLayout: Layout {
    private let engine: StackLayoutEngine
    
    public init(alignment: Alignment.Vertical = .center, spacing: CGFloat = 8) {
        let stackAlignment: StackAlignment = {
            switch alignment {
            case .top:
                return .min
            case .center:
                return .center
            case .bottom:
                return .max
            }
        }()
        
        self.engine = StackLayoutEngine(
            spacing: spacing,
            axis: .horizontal,
            alignment: stackAlignment
        )
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
        self.engine.placeChildren(&children, in: rect)
    }
}
