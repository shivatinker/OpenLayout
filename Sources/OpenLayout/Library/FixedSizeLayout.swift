//
//  FixedSizeLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct FixedSizeLayout: UnaryLayout {
    public let horizontal: Bool
    public let vertical: Bool

    public init(horizontal: Bool, vertical: Bool) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize {
        child.sizeThatFits(proposal: self.childProposal(for: proposal))
    }

    public func placeChild(_ child: some ChildPlacement, bounds: CGRect) {
        child.place(
            at: bounds.center,
            anchor: .center,
            proposal: self.childProposal(for: ProposedSize(bounds.size))
        )
    }

    private func childProposal(for proposal: ProposedSize) -> ProposedSize {
        ProposedSize(
            width: self.horizontal ? nil : proposal.width,
            height: self.vertical ? nil : proposal.height
        )
    }
}
