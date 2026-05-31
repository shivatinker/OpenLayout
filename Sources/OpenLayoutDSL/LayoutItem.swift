//
//  LayoutItem.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import OpenLayout

public protocol LayoutItem { // Like SwiftUI.View
    func makeLayoutNode(context: LayoutContext) -> LayoutNode
}

public protocol BodyLayoutItem: LayoutItem {
    associatedtype Content: LayoutItem
    
    var body: Content { get }
}

extension BodyLayoutItem {
    public func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        self.body.makeLayoutNode(context: context)
    }
}
