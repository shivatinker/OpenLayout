//
//  FixedFrameLayout.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics

extension View {
    @_disfavoredOverload
    func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        FixedFrameLayout(
            width: width,
            height: height,
            alignment: alignment
        ) {
            self
        }
    }
}

private struct FixedFrameLayout: UnaryLayout {
    private static let defaultSize = CGSize(width: 10, height: 10)
    
    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment
    
    func sizeThatFits(
        _ proposal: ProposedSize,
        element: some LayoutElementSizeProvider
    ) -> CGSize {
        let childProposal = self.childProposal(from: proposal)
        var size = element.sizeThatFits(childProposal)
        
        if let width {
            size.width = width
        }
        
        if let height {
            size.height = height
        }
        
        return size
    }
    
    func place(_ element: some LayoutElement, in frame: CGRect) {
        element.place(
            at: self.alignment.anchorPoint(in: frame),
            anchor: self.alignment,
            proposal: self.childProposal(from: ProposedSize(size: frame.size))
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
