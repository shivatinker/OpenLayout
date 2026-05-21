//
//  Background.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import OpenLayout

extension LayoutItem {
    public func background(_ background: some LayoutItem) -> some LayoutItem {
        ContainerItem(
            layout: BackgroundLayout(),
            children: [background, self]
        )
    }
}
