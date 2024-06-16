//
//  Layout+DSL.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

typealias ViewListBuilder = ArrayBuilder<any View>

extension Layout {
    func callAsFunction(@ViewListBuilder _ children: () -> [any View]) -> some View {
        LayoutContainerView(layout: self, children: children())
    }
}

private struct LayoutContainerView<Layout: OpenLayout.Layout>: View {
    let layout: Layout
    let children: [any View]
    
    var body: Never {
        fatalError("Should not be called")
    }
    
    func makeNode() -> Node {
        Node(
            layout: self.layout,
            children: self.children.map { $0.makeNode() }
        )
    }
}
