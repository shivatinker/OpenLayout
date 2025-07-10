//
//  Container.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayoutCore

protocol Container {
    associatedtype Layout: OpenLayoutCore.Layout
    
    func makeLayout() -> Layout
}

extension Container {
    public func callAsFunction(
        @LayoutBuilder content: () -> [any LayoutItem]
    ) -> some LayoutItem {
        ContainerItem(
            layout: self.makeLayout(),
            children: content()
        )
    }
}

private struct ContainerItem<Layout: OpenLayoutCore.Layout>: LayoutItem {
    let layout: Layout
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
