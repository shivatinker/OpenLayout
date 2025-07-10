import CoreGraphics

public struct FixedSizeLayout: UnaryLayout {
    public let horizontal: Bool
    public let vertical: Bool
    
    public init(horizontal: Bool, vertical: Bool) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public func sizeThatFits(
        _ proposal: ProposedSize,
        child: some LayoutSizeProvider
    ) -> CGSize {
        child.sizeThatFits(self.childProposal(for: proposal))
    }
    
    public func placeChild(in rect: CGRect, child: inout some LayoutElement) {
        child.place(
            at: rect.center,
            anchor: .center,
            proposal: self.childProposal(for: ProposedSize(rect.size))
        )
    }
    
    private func childProposal(for proposal: ProposedSize) -> ProposedSize {
        var childProposal = proposal
        if self.horizontal {
            childProposal.width = nil
        }
        if self.vertical {
            childProposal.height = nil
        }
        return childProposal
    }
}
