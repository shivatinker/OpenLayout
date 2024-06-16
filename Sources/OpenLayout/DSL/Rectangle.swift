//
//  Rectangle.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

struct Rectangle: View {
    var body: Never {
        fatalError("Should not be called")
    }
    
    func makeNode() -> Node {
        LeafNode()
    }
}
