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
    
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    public func makeLayout() -> VStackLayout {
        VStackLayout(spacing: self.spacing)
    }
}
