//
//  Layout+DSL.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayoutCore

extension Layout {
    public func callAsFunction(
        @LayoutBuilder content: () -> [any LayoutItemConvertible]
    ) -> some LayoutItem {
        let content = content()
        let children = content.map { item in item.layoutItem }
        return Container(layout: self, children: children)
    }
}

private struct Container<L: Layout>: LayoutItem, LayoutItemConvertible {
    let layout: L
    let children: [any LayoutItem]
    
    func makeNode() -> LayoutNode {
        LayoutNode.makeContainer(
            layout: self.layout,
            children: self.children.map { $0.makeNode() }
        )
    }
    
    var layoutItem: some LayoutItem {
        self
    }
}
