//
//  VStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct VStackLayout: Layout {
    public let alignment: Alignment.Horizontal
    public let spacing: CGFloat
    private let engine: StackLayoutEngine

    public init(alignment: Alignment.Horizontal = .center, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
        self.engine = StackLayoutEngine(spacing: spacing, majorAxis: .vertical, alignment: alignment.stackAlignment)
    }

    public func sizeThatFits(_ children: [ChildMeasurement], proposal: ProposedSize) -> CGSize {
        self.engine.sizeThatFits(proposal, children: children)
    }

    public func placeChildren(_ children: [ChildPlacement], bounds: CGRect) {
        self.engine.placeChildren(children, in: bounds)
    }
    
    public func layoutDirection() -> Axis? {
        .vertical
    }
}
