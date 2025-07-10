//
//  VStack.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

public struct VStack: Container {
    public typealias Layout = VStackLayout
    
    private let spacing: CGFloat
    private let alignment: Alignment.Horizontal
    
    public init(alignment: Alignment.Horizontal = .center, spacing: CGFloat = 8) {
        self.spacing = spacing
        self.alignment = alignment
    }
    
    public func makeLayout() -> VStackLayout {
        VStackLayout(alignment: self.alignment, spacing: self.spacing)
    }
}
