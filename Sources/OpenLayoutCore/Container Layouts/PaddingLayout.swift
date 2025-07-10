import CoreGraphics

public struct PaddingLayout: UnaryLayout {
    public let edges: Edge.Set
    public let padding: CGFloat
    
    public init(edges: Edge.Set, padding: CGFloat) {
        precondition(padding >= 0)
        self.edges = edges
        self.padding = padding
    }
    
    public func sizeThatFits(
        _ proposal: ProposedSize,
        child: some LayoutSizeProvider
    ) -> CGSize {
        let childProposal = self.childProposal(for: proposal)
        let childSize = child.sizeThatFits(childProposal)
        return childSize.inset(edges: self.edges, -self.padding)
    }
    
    public func placeChild(in rect: CGRect, child: inout some LayoutElement) {
        let childFrame = rect.inset(edges: self.edges, self.padding)
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
