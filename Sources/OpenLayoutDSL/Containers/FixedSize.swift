//
//  FixedSize.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import OpenLayout

extension LayoutItem {
    public func fixedSize() -> some LayoutItem {
        self.fixedSize(horizontal: true, vertical: true)
    }

    public func fixedSize(horizontal: Bool, vertical: Bool) -> some LayoutItem {
        UnaryContainerItem(
            layout: FixedSizeLayout(horizontal: horizontal, vertical: vertical),
            child: self
        )
    }
}
