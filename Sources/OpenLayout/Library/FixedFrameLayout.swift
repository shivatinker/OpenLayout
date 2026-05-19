//
//  FixedFrameLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct FixedFrameLayout: UnaryLayout {
    public let width: CGFloat?
    public let height: CGFloat?
    public let alignment: Alignment

    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }

    public func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize {
        let childProposal = self.childProposal(from: proposal)
        var size = child.sizeThatFits(proposal: childProposal)

        if let width {
            size.width = width
        }

        if let height {
            size.height = height
        }

        return size
    }

    public func placeChild(_ child: some ChildPlacement, bounds: CGRect) {
        let anchorPoint = self.alignment.anchorPoint
        child.place(
            at: bounds.anchorPoint(anchorPoint),
            anchor: anchorPoint,
            proposal: self.childProposal(from: ProposedSize(bounds.size))
        )
    }

    private func childProposal(from proposal: ProposedSize) -> ProposedSize {
        ProposedSize(
            width: self.width ?? proposal.width,
            height: self.height ?? proposal.height
        )
    }
}
