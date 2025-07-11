import CoreGraphics

public struct FlexibleFrameLayout: UnaryLayout {
    public let minWidth: CGFloat?
    public let maxWidth: CGFloat?
    public let minHeight: CGFloat?
    public let maxHeight: CGFloat?
    public let alignment: Alignment

    public init(
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
    }

    // Logic here is dark magic, be very careful with it
    public func sizeThatFits(
        _ proposal: ProposedSize,
        child: some LayoutSizeProvider
    ) -> CGSize {
        let childSize = child.sizeThatFits(proposal)

        let width = self.calculateConstrainedDimension(
            childValue: childSize.width,
            proposalValue: proposal.width,
            minValue: self.minWidth,
            maxValue: self.maxWidth
        )
        
        let height = self.calculateConstrainedDimension(
            childValue: childSize.height,
            proposalValue: proposal.height,
            minValue: self.minHeight,
            maxValue: self.maxHeight
        )

        return self.constrained(CGSize(width: width, height: height))
    }

    private func calculateConstrainedDimension(
        childValue: CGFloat,
        proposalValue: CGFloat?,
        minValue: CGFloat?,
        maxValue: CGFloat?
    ) -> CGFloat {
        var result = childValue
        
        if let minValue, let maxValue {
            result = proposalValue?.clamped(to: minValue...maxValue) ??
                childValue.clamped(to: minValue...maxValue)
        }
        else if let minValue, let proposalValue, proposalValue <= childValue {
            result = max(minValue, proposalValue)
        }
        else if let maxValue, let proposalValue, proposalValue >= childValue {
            result = min(maxValue, proposalValue)
        }
        
        return result
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

extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
