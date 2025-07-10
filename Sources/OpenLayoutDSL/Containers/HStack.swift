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
    
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    public func makeLayout() -> HStackLayout {
        HStackLayout(spacing: self.spacing)
    }
}
