//
//  UnaryLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreFoundation

public protocol UnaryLayout {
    func sizeThatFits(_ proposal: ProposedSize, child: some LayoutSizeProvider) -> CGSize
    func placeChild(in rect: CGRect, child: inout some LayoutElement)
}

extension UnaryLayout {
    func makeAdapter() -> some Layout {
        UnaryLayoutAdapter(layout: self)
    }
}

private struct UnaryLayoutAdapter: Layout {
    let layout: UnaryLayout
    
    func sizeThatFits(_ proposal: ProposedSize, children: [some LayoutSizeProvider]) -> CGSize {
        guard let child = children.onlyElement else {
            assertionFailure()
            return .zero
        }
        
        return self.layout.sizeThatFits(proposal, child: child)
    }
    
    func placeChildren(in rect: CGRect, children: inout [some LayoutElement]) {
        guard children.count == 1 else {
            assertionFailure()
            return
        }
        
        self.layout.placeChild(in: rect, child: &children[0])
    }
}

struct TransparentLayout: UnaryLayout {
    func sizeThatFits(_ proposal: ProposedSize, child: some LayoutSizeProvider) -> CGSize {
        child.sizeThatFits(proposal)
    }
    
    func placeChild(in rect: CGRect, child: inout some LayoutElement) {
        child.place(at: rect.center, anchor: .center, proposal: ProposedSize(rect.size))
    }
}

extension Collection {
    var onlyElement: Element? {
        guard self.count == 1 else { return nil }
        return self.first
    }
}
