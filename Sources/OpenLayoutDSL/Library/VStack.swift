//
//  VStack.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout

public struct VStack: Container {
    public typealias Layout = VStackLayout

    private let spacing: CGFloat
    private let alignment: Alignment.Horizontal

    public init(
        alignment: Alignment.Horizontal = .center,
        spacing: CGFloat = LayoutConfiguration.defaultVStackSpacing
    ) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func makeLayout() -> VStackLayout {
        VStackLayout(alignment: self.alignment, spacing: self.spacing)
    }
}
