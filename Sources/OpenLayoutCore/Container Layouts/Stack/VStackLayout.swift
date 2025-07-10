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
        // Layout as if origin is (0,0)
        let zeroOriginRect = CGRect(origin: .zero, size: rect.size)
        let childrenPlacements = self.engine.placeChildren(children, in: zeroOriginRect)
        
        for (index, placement) in childrenPlacements.enumerated() {
            // Swap back, then translate by rect.origin
            let swappedPoint = placement.0.swapped()
            let translatedPoint = CGPoint(
                x: swappedPoint.x + rect.origin.x,
                y: swappedPoint.y + rect.origin.y
            )
            children[index].place(
                at: translatedPoint,
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
