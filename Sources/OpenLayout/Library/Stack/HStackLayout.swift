//
//  HStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct HStackLayout: ContainerLayout {
    private let engine: StackLayoutEngine

    public init(alignment: Alignment.Vertical = .center, spacing: CGFloat) {
        self.engine = StackLayoutEngine(spacing: spacing, axis: .horizontal, alignment: alignment.stackAlignment)
    }

    public func sizeThatFits(_ children: [ChildMeasurement], proposal: ProposedSize) -> CGSize {
        self.engine.sizeThatFits(proposal, children: children)
    }

    public func placeChildren(_ children: [ChildPlacement], bounds: CGRect) {
        self.engine.placeChildren(children, in: bounds)
    }
}
