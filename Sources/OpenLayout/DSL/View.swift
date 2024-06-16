//
//  View.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

protocol View {
    associatedtype Body: View
    
    var body: Body { get }
    
    func makeNode() -> Node
}

extension View {
    func makeNode() -> Node {
        self.body.makeNode()
    }
}

extension Never: View {
    var body: Never {
        fatalError("Should not be called")
    }
}
