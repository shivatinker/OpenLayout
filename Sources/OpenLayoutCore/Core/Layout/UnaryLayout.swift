//
//  UnaryLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreFoundation

public protocol UnaryLayout {
    func sizeThatFits(_ size: ProposedSize, child: some LayoutSizeProvider) -> CGSize
    func placeChild(in rect: CGRect, child: inout some LayoutElement)
}

extension UnaryLayout {
    func makeAdapter() -> some Layout {
        UnaryLayoutAdapter(layout: self)
    }
}

private struct UnaryLayoutAdapter: Layout {
    let layout: UnaryLayout
    
    func sizeThatFits(_ size: ProposedSize, children: [some LayoutSizeProvider]) -> CGSize {
        guard let child = children.onlyElement else {
            assertionFailure()
            return .zero
        }
        
        return self.layout.sizeThatFits(size, child: child)
    }
    
    func placeChildren(in rect: CGRect, children: inout [some LayoutElement]) {
        guard children.count == 1 else {
            assertionFailure()
            return
        }
        
        self.layout.placeChild(in: rect, child: &children[0])
    }
}

extension Collection {
    var onlyElement: Element? {
        guard self.count == 1 else { return nil }
        return self.first
    }
}
