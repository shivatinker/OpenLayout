//
//  Container.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayoutCore

public protocol Container {
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

struct UnaryContainerItem<Layout: UnaryLayout>: LayoutItem {
    let layout: Layout
    let child: any LayoutItem
    
    func makeNode() -> LayoutNode {
        LayoutNode.makeUnaryContainer(
            layout: self.layout,
            child: self.child.makeNode()
        )
    }
}

struct ContainerItem<Layout: OpenLayoutCore.Layout>: LayoutItem {
    let layout: Layout
    let children: [any LayoutItem]
    
    func makeNode() -> LayoutNode {
        LayoutNode.makeContainer(
            layout: self.layout,
            children: self.children.map { $0.makeNode() }
        )
    }
}
