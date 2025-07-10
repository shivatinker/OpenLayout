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
