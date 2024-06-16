//
//  FixedSize.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics

extension View {
    func fixedSize() -> some View {
        self.fixedSize(horizontal: true, vertical: true)
    }
    
    func fixedSize(horizontal: Bool, vertical: Bool) -> some View {
        FixedSize(horizontal: horizontal, vertical: vertical) {
            self
        }
    }
}

private struct FixedSize: UnaryLayout {
    let horizontal: Bool
    let vertical: Bool
    
    func sizeThatFits(_ proposal: ProposedSize, element: some LayoutElementSizeProvider) -> CGSize {
        element.sizeThatFits(self.childProposal(for: proposal))
    }
    
    func place(_ element: some LayoutElement, in frame: CGRect) {
        element.place(
            at: frame.center,
            anchor: .center,
            proposal: self.childProposal(for: ProposedSize(size: frame.size))
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
