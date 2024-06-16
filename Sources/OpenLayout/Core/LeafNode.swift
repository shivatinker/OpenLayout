//
//  LeafNode.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

final class LeafNode: Node {
    init(layout: some LeafLayout = DefaultLeafLayout()) {
        super.init(layout: layout, children: [])
    }
}
