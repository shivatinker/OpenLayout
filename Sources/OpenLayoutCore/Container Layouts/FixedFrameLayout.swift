//
//  FixedFrameLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct FixedFrameLayout: UnaryLayout {
    private static let defaultSize = CGSize(width: 10, height: 10)
    
    public let width: CGFloat?
    public let height: CGFloat?
    public let alignment: Alignment
    
    @available(*, unavailable, message: "Provide one of width or height")
    public init(
        alignment: Alignment = .center
    ) {
        fatalError("Provide one of width or height")
    }
    
    @_disfavoredOverload
    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }
    
    public func sizeThatFits(
        _ proposal: ProposedSize,
        child: some LayoutSizeProvider
    ) -> CGSize {
        let childProposal = self.childProposal(from: proposal)
        var size = child.sizeThatFits(childProposal)
        
        if let width {
            size.width = width
        }
        
        if let height {
            size.height = height
        }
        
        return size
    }
    
    public func placeChild(in rect: CGRect, child: inout some LayoutElement) {
        child.place(
            at: self.alignment.anchorPoint(in: rect),
            anchor: self.alignment,
            proposal: self.childProposal(from: ProposedSize(rect.size))
        )
    }
    
    private func childProposal(from proposal: ProposedSize) -> ProposedSize {
        var childProposal = proposal
        
        if let width {
            childProposal.width = width
        }
        
        if let height {
            childProposal.height = height
        }
        
        return childProposal
    }
}
