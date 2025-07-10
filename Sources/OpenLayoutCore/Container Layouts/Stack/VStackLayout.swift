//
//  VStackLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

public struct VStackLayout: Layout {
    private let engine: StackLayoutEngine
    
    public init(spacing: CGFloat = 8) {
        self.engine = StackLayoutEngine(spacing: 8)
    }
    
    public func sizeThatFits(
        _ proposition: ProposedSize,
        children: [some LayoutSizeProvider]
    ) -> CGSize {
        self.engine.sizeThatFits(
            proposition.swapped(),
            children: children.map(SwappedLayoutElementSizeProvider.init(element:))
        ).swapped()
    }
    
    public func placeChildren(
        in rect: CGRect,
        children: inout [some LayoutElement]
    ) {
        let childrenPlacements = self.engine.placeChildren(children, in: rect)
        
        for (index, placement) in childrenPlacements.enumerated() {
            children[index].place(
                at: placement.0.swapped(),
                anchor: .topLeft,
                proposal: placement.1.swapped()
            )
        }
    }
}

private struct SwappedLayoutElementSizeProvider: LayoutSizeProvider {
    let element: LayoutSizeProvider
    
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        self.element.sizeThatFits(proposal.swapped()).swapped()
    }
}

extension ProposedSize {
    func swapped() -> ProposedSize {
        ProposedSize(width: self.height, height: self.width)
    }
}

extension CGPoint {
    func swapped() -> CGPoint {
        CGPoint(x: self.y, y: self.x)
    }
}

extension CGSize {
    func swapped() -> CGSize {
        CGSize(width: self.height, height: self.width)
    }
}

extension CGRect {
    func swapped() -> CGRect {
        CGRect(
            origin: self.origin.swapped(),
            size: self.size.swapped()
        )
    }
}
