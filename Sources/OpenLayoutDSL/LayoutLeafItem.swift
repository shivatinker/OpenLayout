//
//  LayoutLeafItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

public protocol LayoutLeafItem: LayoutItemConvertible {
    associatedtype Layout: LeafLayout
    
    var layout: Layout { get }
}

extension LayoutLeafItem {
    public var layoutItem: some LayoutItem {
        Leaf(self)
    }
}

private struct Leaf<T: LayoutLeafItem>: LayoutItem {
    typealias Content = Never
    
    private let item: T
    
    init(_ item: T) {
        self.item = item
    }
    
    func makeNode() -> LayoutNode {
        LayoutNode.makeLeaf(layout: self.item.layout, item: self.item)
    }
}
