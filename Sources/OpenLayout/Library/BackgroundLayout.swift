//
//  BackgroundLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct BackgroundLayout: ContainerLayout {
    public init() {}

    public func sizeThatFits(_ children: [ChildMeasurement], proposal: ProposedSize) -> CGSize {
        guard children.count == 2 else {
            assertionFailure("BackgroundLayout expects exactly 2 children")
            return .zero
        }
        
        return children[1].sizeThatFits(proposal: proposal)
    }

    public func placeChildren(_ children: [ChildPlacement], bounds: CGRect) {
        guard children.count == 2 else {
            assertionFailure("BackgroundLayout expects exactly 2 children")
            return
        }

        let proposal = ProposedSize(bounds.size)
        children[0].place(at: bounds.center, anchor: .center, proposal: proposal)
        children[1].place(at: bounds.center, anchor: .center, proposal: proposal)
    }
}
