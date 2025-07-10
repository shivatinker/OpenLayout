//
//  FixedFrame.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayoutCore

extension LayoutItem {
    @_disfavoredOverload
    public func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some LayoutItem {
        UnaryContainerItem(
            layout: FixedFrameLayout(
                width: width,
                height: height,
                alignment: alignment
            ),
            child: self
        )
    }
}
