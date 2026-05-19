//
//  HStack.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout

public struct HStack: Container {
    public typealias Layout = HStackLayout

    private let spacing: CGFloat
    private let alignment: Alignment.Vertical

    public init(alignment: Alignment.Vertical = .center, spacing: CGFloat = 8) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func makeLayout() -> HStackLayout {
        HStackLayout(alignment: self.alignment, spacing: self.spacing)
    }
}
