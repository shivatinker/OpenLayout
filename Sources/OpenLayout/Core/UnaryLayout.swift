//
//  UnaryLayout.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

import CoreGraphics

protocol UnaryLayout: Layout {
    func sizeThatFits(
        _ proposal: ProposedSize,
        element: some LayoutElementSizeProvider
    ) -> CGSize
    
    func place(
        _ element: some LayoutElement,
        in frame: CGRect
    )
}

extension UnaryLayout {
    func sizeThatFits(_ proposal: ProposedSize, children: [some LayoutElementSizeProvider]) -> CGSize {
        guard let element = children.first, children.count == 1 else {
            preconditionFailure()
        }
        
        return self.sizeThatFits(proposal, element: element)
    }
    
    func placeChildren(_ children: [some LayoutElement], in frame: CGRect) {
        guard let element = children.first, children.count == 1 else {
            preconditionFailure()
        }
        
        self.place(element, in: frame)
    }
}
