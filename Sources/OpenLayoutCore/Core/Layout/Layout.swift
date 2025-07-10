//
//  Layout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 09.07.2025.
//

import CoreGraphics

public protocol LayoutSizeProvider {
    func sizeThatFits(_ size: ProposedSize) -> CGSize
}

extension LayoutSizeProvider {
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

public protocol LayoutElement: LayoutSizeProvider {
    mutating func place(at point: CGPoint, anchor: Alignment, proposal: ProposedSize)
}

public protocol Layout {
    func sizeThatFits(_ size: ProposedSize, children: [some LayoutSizeProvider]) -> CGSize
    func placeChildren(in rect: CGRect, children: inout [some LayoutElement])
}
