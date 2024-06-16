//
//  VStack.swift
//
//
//  Created by Andrii Zinoviev on 13.06.2024.
//

import CoreGraphics

struct VStack: HVStack {
    private let engine: StackLayoutEngine
    
    init(spacing: CGFloat = Self.defaultSpacing) {
        self.engine = StackLayoutEngine(spacing: spacing)
    }
    
    func sizeThatFits(
        _ proposal: ProposedSize,
        children: [some LayoutElementSizeProvider]
    ) -> CGSize {
        self.engine.sizeThatFits(
            proposal.swapped(),
            children: children.map(SwappedLayoutElementSizeProvider.init(element:))
        ).swapped()
    }
    
    func placeChildren(
        _ children: [some LayoutElement],
        in frame: CGRect
    ) {
        self.engine.placeChildren(
            children.map(SwappedLayoutElement.init(element:)),
            in: frame.swapped()
        )
    }
}

private struct SwappedLayoutElementSizeProvider: LayoutElementSizeProvider {
    let element: LayoutElementSizeProvider
    
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        self.element.sizeThatFits(proposal.swapped()).swapped()
    }
}

private struct SwappedLayoutElement: LayoutElement {
    let element: LayoutElement
    
    func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        self.element.sizeThatFits(proposal.swapped()).swapped()
    }

    func place(at point: CGPoint, anchor: Alignment, proposal: ProposedSize) {
        self.element.place(
            at: point.swapped(),
            anchor: anchor.swapped(),
            proposal: proposal.swapped()
        )
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
