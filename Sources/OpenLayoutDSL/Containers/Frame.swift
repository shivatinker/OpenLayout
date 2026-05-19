//
//  Frame.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout

extension LayoutItem {
    @available(*, unavailable, message: "Please pass at least one dimension parameter")
    public func frame() -> some LayoutItem {
        fatalError()
    }

    @available(*, unavailable, message: "Please pass at least one dimension parameter")
    public func frame(alignment: Alignment) -> some LayoutItem {
        fatalError()
    }

    @_disfavoredOverload
    public func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some LayoutItem {
        UnaryContainerItem(
            layout: FixedFrameLayout(width: width, height: height, alignment: alignment),
            child: self
        )
    }

    @_disfavoredOverload
    public func frame(
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some LayoutItem {
        UnaryContainerItem(
            layout: FlexibleFrameLayout(
                minWidth: minWidth,
                maxWidth: maxWidth,
                minHeight: minHeight,
                maxHeight: maxHeight,
                alignment: alignment
            ),
            child: self
        )
    }
}
