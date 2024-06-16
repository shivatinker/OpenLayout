//
//  Layout.swift
//
//
//  Created by Andrii Zinoviev on 12.06.2024.
//

import CoreGraphics

protocol LayoutElementSizeProvider {
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize
}

extension LayoutElementSizeProvider {
    func idealSize() -> CGSize {
        self.sizeThatFits(.unspecified)
    }
    
    func minSize() -> CGSize {
        self.sizeThatFits(.zero)
    }
    
    func maxSize() -> CGSize {
        self.sizeThatFits(.infinity)
    }
}

protocol LayoutElement: LayoutElementSizeProvider {
    func place(at point: CGPoint, anchor: Alignment, proposal: ProposedSize)
}

protocol Layout {
    func sizeThatFits(
        _ proposal: ProposedSize,
        children: [some LayoutElementSizeProvider]
    ) -> CGSize
    
    func placeChildren(
        _ children: [some LayoutElement],
        in frame: CGRect
    )
}
