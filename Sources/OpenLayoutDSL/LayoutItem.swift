//
//  LayoutItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import OpenLayoutCore

// MARK: LayoutItem

public protocol LayoutItem {
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

extension LayoutItem {
    public func attribute<Key: NodeAttributeKey>(
        _ key: Key.Type,
        _ value: Key.Value
    ) -> some LayoutItem {
        AttributeItem(
            attributes: NodeAttributes(key: key, value: value),
            content: self
        )
    }
}

private struct AttributeItem<Content: LayoutItem>: LayoutItem {
    let attributes: NodeAttributes
    let content: Content
    
    public func makeNode() -> LayoutNode {
        LayoutNode.makeAttributeNode(
            attributes: self.attributes,
            child: self.content.makeNode()
        )
    }
}
