//
//  NodeVisitor.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

protocol NodeVisitor {
    mutating func visit(_ node: Node)
}
