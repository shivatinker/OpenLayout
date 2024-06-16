//
//  LayoutDumper.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics
@testable import OpenLayout

extension Node {
    func dumpTags() -> String {
        var dumper = LayoutDumper()
       
        self.accept(&dumper)
        
        return dumper.dump()
    }
}

private struct LayoutDumper: NodeVisitor {
    struct Entry: CustomStringConvertible {
        let tag: Int
        let frame: CGRect?
        
        var description: String {
            "\(self.tag): \(optional: self.frame)"
        }
    }
    
    private var result: [Entry] = []
    
    mutating func visit(_ node: Node) {
        for tag in node.info.tags {
            self.result.append(Entry(tag: tag, frame: node.frame))
        }
    }
    
    func dump() -> String {
        self.result.sorted(key: \.tag).map(\.description).joined(separator: "\n")
    }
}

extension DefaultStringInterpolation {
    public mutating func appendInterpolation<T>(optional: T?) {
        if let optional {
            self.appendInterpolation(optional)
        }
        else {
            self.appendInterpolation("<nil>")
        }
    }
}
