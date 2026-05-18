//
//  LayoutItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import OpenLayout

public protocol LayoutItem {
    func makeLayoutNode(context: LayoutContext) -> LayoutNode
}

public protocol BodyLayoutItem: LayoutItem {
    associatedtype Content: LayoutItem = Never
    
    var body: Content { get }
}

extension Never: BodyLayoutItem {
    public var body: Never {
        fatalError("Should not be called")
    }
}

extension BodyLayoutItem {
    public func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        self.body.makeLayoutNode(context: context)
    }
}
