//
//  Container.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import OpenLayout

public protocol Container {
    associatedtype Layout: ContainerLayout
    
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
    
    func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeUnaryNode(
            context: context,
            layout: self.layout,
            child: self.child.makeLayoutNode(context: context)
        )
    }
}

struct ContainerItem<Layout: ContainerLayout>: LayoutItem {
    let layout: Layout
    let children: [any LayoutItem]
    
    func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeContainerNode(
            context: context,
            layout: self.layout,
            children: self.children.map { $0.makeLayoutNode(context: context) }
        )
    }
}
