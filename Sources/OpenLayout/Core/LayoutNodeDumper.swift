//
//  LayoutNodeDumper.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

public struct LayoutNodeDumper {
    private let indentStep: Int

    public init(indentStep: Int = 2) {
        self.indentStep = indentStep
    }

    public func dump(_ node: LayoutNode) -> String {
        var lines: [String] = []
        self.collect(node, indent: 0, into: &lines)
        return lines.joined(separator: "\n")
    }

    private func collect(_ node: LayoutNode, indent: Int, into lines: inout [String]) {
        let frameDesc: String
        if let frame = node.frame {
            frameDesc = "(\(frame.origin.x), \(frame.origin.y)) \(frame.width)×\(frame.height)"
        }
        else {
            frameDesc = "unplaced"
        }
        lines.append("\(String(repeating: " ", count: indent))\(node) \(frameDesc)")
        for child in node.children {
            self.collect(child, indent: indent + self.indentStep, into: &lines)
        }
    }
}
