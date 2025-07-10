//
//  VStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct VStackLayout: Layout {
    private let engine: StackLayoutEngine
    
    public init(alignment: Alignment.Horizontal = .center, spacing: CGFloat = 8) {
        let stackAlignment: StackAlignment = {
            switch alignment {
            case .left:
                return .min
            case .center:
                return .center
            case .right:
                return .max
            }
        }()
        
        self.engine = StackLayoutEngine(
            spacing: spacing,
            axis: .vertical,
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
