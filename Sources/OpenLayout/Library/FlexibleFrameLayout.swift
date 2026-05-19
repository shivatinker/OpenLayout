//
//  FlexibleFrameLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

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
    public func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize {
        let childSize = child.sizeThatFits(proposal: proposal)

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

    public func placeChild(_ child: some ChildPlacement, bounds: CGRect) {
        let constrainedSize = self.constrained(bounds.size)
        let anchorPoint = self.alignment.anchorPoint
        child.place(
            at: bounds.anchorPoint(anchorPoint),
            anchor: anchorPoint,
            proposal: ProposedSize(constrainedSize)
        )
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
