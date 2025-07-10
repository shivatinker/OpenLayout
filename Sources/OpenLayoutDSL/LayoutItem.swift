//
//  LayoutItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

// MARK: LayoutItem

public protocol LayoutItem: LayoutItemConvertible {
    associatedtype Content: LayoutItem
    
    var body: Content { get }
    
    func makeNode() -> LayoutNode
}

extension Never: LayoutItem {
    public var body: Never {
        fatalError("Should not be called")
    }
}

extension LayoutItem where Content == Never {
    public var body: Never {
        fatalError("Should not be called")
    }
}

extension LayoutItem {
    public func makeNode() -> LayoutNode {
        self.body.makeNode()
    }
}

// MARK: LayoutItemConvertible

public protocol LayoutItemConvertible {
    associatedtype Item: LayoutItem
    
    var layoutItem: Item { get }
}

extension LayoutItem {
    public var layoutItem: Self {
        self
    }
}
