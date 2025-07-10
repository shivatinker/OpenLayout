//
//  StackLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

// Horizontal stack layout
struct StackLayoutEngine {
    let spacing: CGFloat
    
    func sizeThatFits(
        _ proposal: ProposedSize,
        children: [some LayoutSizeProvider]
    ) -> CGSize {
        guard let totalWidth = proposal.width else {
            // Just use ideal widths for children
            let idealSizes = children.map { $0.idealSize() }
            
            return self.sizeThatFits(childrenSizes: idealSizes)
        }
        
        let sizes = self.calculateSizes(
            for: children,
            totalWidth: totalWidth,
            height: proposal.height
        )
        
        return self.sizeThatFits(childrenSizes: sizes.map(\.size))
    }
    
    private func sizeThatFits(childrenSizes: [CGSize]) -> CGSize {
        let totalSpacing: CGFloat = self.spacing * (CGFloat(childrenSizes.count) - 1)
        
        return CGSize(
            width: childrenSizes.map(\.width).reduce(0, +) + totalSpacing,
            height: childrenSizes.map(\.height).reduce(0, max)
        )
    }
    
    func placeChildren(
        _ children: [some LayoutSizeProvider],
        in frame: CGRect
    ) -> [(CGPoint, ProposedSize)] {
        let sizes = self.calculateSizes(
            for: children,
            totalWidth: frame.size.width,
            height: frame.size.height
        )
        
        var origin = frame.origin
        
        var result: [(CGPoint, ProposedSize)] = []
        
        for element in sizes {
            result.append((origin, element.proposal))
            origin.x += element.size.width + self.spacing
        }
        
        return result
    }
    
    private struct CalculatedElement {
        let proposal: ProposedSize
        let size: CGSize
    }
    
    private func calculateSizes(
        for children: [some LayoutSizeProvider],
        totalWidth: CGFloat,
        height: CGFloat?
    ) -> [CalculatedElement] {
        let sortedIndices = children
            .map { self.flexibility(for: $0, height: height) }
            .enumerated()
            .sorted { $0.1 < $1.1 }
            .map(\.offset)
        
        var result: [CalculatedElement] = Array(
            repeating: CalculatedElement(proposal: .unspecified, size: .zero),
            count: children.count
        )
        
        var remainingCount = children.count
        var remainingWidth = totalWidth
        
        for index in sortedIndices {
            let element = children[index]
            
            precondition(remainingCount > 0)
            let totalRemainingSpacing: CGFloat = self.spacing * (CGFloat(remainingCount) - 1)
            
            let remainingWidthWithoutSpacing: CGFloat = max(remainingWidth - totalRemainingSpacing, 0)
            
            let proposal = ProposedSize(
                width: remainingWidthWithoutSpacing / CGFloat(remainingCount),
                height: height
            )
            
            let size = element.sizeThatFits(proposal)
            
            result[index] = CalculatedElement(
                proposal: proposal,
                size: size
            )
            
            remainingWidth = max(remainingWidth - size.width - self.spacing, 0)
            remainingCount -= 1
        }
        
        return result
    }
    
    private func flexibility(for element: LayoutSizeProvider, height: CGFloat?) -> CGFloat {
        let minWidth = element.sizeThatFits(ProposedSize(width: 0, height: height)).width
        let maxWidth = element.sizeThatFits(ProposedSize(width: .infinity, height: height)).width
        
        precondition(minWidth <= maxWidth)
        return maxWidth - minWidth
    }
}

extension CGSize {
    static let zero = CGSize(width: 0, height: 0)
}
