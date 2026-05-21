//
//  Padding.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import CoreFoundation
import OpenLayout

extension LayoutItem {
    public func padding(_ padding: CGFloat) -> some LayoutItem {
        self.padding(.all, padding)
    }
    
    public func padding(
        _ edges: Edge.Set,
        _ padding: CGFloat
    ) -> some LayoutItem {
        UnaryContainerItem(
            layout: PaddingLayout(edges: edges, padding: padding),
            child: self
        )
    }
}
