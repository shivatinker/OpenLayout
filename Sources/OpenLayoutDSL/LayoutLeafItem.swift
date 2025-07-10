//
//  LayoutLeafItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

public protocol LayoutLeafItem: LayoutItem {
    associatedtype Layout: LeafLayout
    
    var layout: Layout { get }
}

extension LayoutLeafItem {
    public func makeNode() -> LayoutNode {
        LayoutNode.makeLeaf(layout: self.layout, item: self)
    }
}
