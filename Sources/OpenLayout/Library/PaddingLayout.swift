//
//  PaddingLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 14.05.2026.
//

import CoreFoundation

public struct PaddingLayout: UnaryLayout {
    public let edges: Edge.Set
    public let padding: CGFloat

    public init(edges: Edge.Set, padding: CGFloat) {
        precondition(padding >= 0)
        self.edges = edges
        self.padding = padding
    }
    
    public func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize {
        let childProposal = self.childProposal(for: proposal)
        let childSize = child.sizeThatFits(proposal: childProposal)
        return childSize.inset(edges: self.edges, -self.padding)
    }
    
    public func placeChild(_ child: some ChildPlacement, bounds: CGRect) {
        let childFrame = bounds.inset(edges: self.edges, self.padding)
        let childProposal = ProposedSize(childFrame.size)
        
        child.place(
            at: childFrame.center,
            anchor: .center,
            proposal: childProposal
        )
    }
    
    private func childProposal(for proposal: ProposedSize) -> ProposedSize {
        let size = proposal
            .replacingUnspecifiedDimensions(by: .zero)
            .inset(edges: self.edges, self.padding)
        
        return ProposedSize(
            width: proposal.width == nil ? nil : size.width,
            height: proposal.height == nil ? nil : size.height
        )
    }
}
