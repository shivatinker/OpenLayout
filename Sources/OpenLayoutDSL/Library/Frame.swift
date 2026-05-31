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
        UnaryContainerItem(
            layout: FixedFrameLayout(width: nil, height: nil, alignment: .center),
            child: self
        )
    }

    @available(*, unavailable, message: "Please pass at least one dimension parameter")
    public func frame(alignment: Alignment) -> some LayoutItem {
        UnaryContainerItem(
            layout: FlexibleFrameLayout(
                minWidth: nil,
                maxWidth: nil,
                minHeight: nil,
                maxHeight: nil,
                alignment: alignment
            ),
            child: self
        )
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
