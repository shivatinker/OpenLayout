//
//  Spacer.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 21.05.2026.
//

import CoreFoundation
import OpenLayout

public struct Spacer: LayoutItem {
    public let minLength: CGFloat
    
    public init(minLength: CGFloat = 8) {
        self.minLength = minLength
    }
    
    public func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: SpacerLayout(
                minLength: self.minLength,
                layoutDirection: context.layoutDirection
            ),
            data: nil
        )
    }
}
