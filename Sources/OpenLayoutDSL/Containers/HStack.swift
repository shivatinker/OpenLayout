//
//  HStack.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

public struct HStack: Container {
    public typealias Layout = HStackLayout
    
    private let spacing: CGFloat
    private let alignment: Alignment.Vertical
    
    public init(alignment: Alignment.Vertical = .center, spacing: CGFloat = 8) {
        self.spacing = spacing
        self.alignment = alignment
    }
    
    public func makeLayout() -> HStackLayout {
        HStackLayout(alignment: self.alignment, spacing: self.spacing)
    }
}
