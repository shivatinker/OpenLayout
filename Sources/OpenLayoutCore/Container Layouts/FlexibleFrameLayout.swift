import CoreGraphics

public struct FlexibleFrameLayout: UnaryLayout {
    private static let defaultSize = CGSize(width: 10, height: 10)

    public let minWidth: CGFloat?
    public let maxWidth: CGFloat?
    public let idealWidth: CGFloat?
    public let minHeight: CGFloat?
    public let maxHeight: CGFloat?
    public let idealHeight: CGFloat?
    public let alignment: Alignment

    public init(
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.idealWidth = idealWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.idealHeight = idealHeight
        self.alignment = alignment
    }

    public func sizeThatFits(
        _ proposal: ProposedSize,
        child: some LayoutSizeProvider
    ) -> CGSize {
        // Fill in unspecified proposal dimensions with ideal/default
        let width = proposal.width ?? self.idealWidth ?? Self.defaultSize.width
        let height = proposal.height ?? self.idealHeight ?? Self.defaultSize.height
        let childProposal = ProposedSize(width: width, height: height)
        let childSize = child.sizeThatFits(childProposal)
        // Clamp the result to min/max
        return self.constrained(childSize)
    }

    public func placeChild(in rect: CGRect, child: inout some LayoutElement) {
        let proposal = ProposedSize(self.constrained(rect.size))
        child.place(
            at: self.alignment.anchorPoint(in: rect),
            anchor: self.alignment,
            proposal: proposal
        )
    }

    private func constrained(_ size: CGSize) -> CGSize {
        CGSize(
            width: self.constrained(size.width, minValue: self.minWidth, maxValue: self.maxWidth),
            height: self.constrained(size.height, minValue: self.minHeight, maxValue: self.maxHeight)
        )
    }

    private func constrained(_ value: CGFloat, minValue: CGFloat?, maxValue: CGFloat?) -> CGFloat {
        var result = value
        if let minValue {
            result = max(result, minValue)
        }
        if let maxValue {
            result = min(result, maxValue)
        }
        return result
    }
}
