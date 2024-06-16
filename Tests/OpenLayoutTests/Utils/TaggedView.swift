//
//  TaggedView.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

@testable import OpenLayout

struct TagNodeInfoKey: NodeInfoKey {
    typealias Value = Set<Int>
    
    static func defaultValue() -> Set<Int> {
        []
    }
}

extension NodeInfo {
    var tags: Set<Int> {
        get {
            self[TagNodeInfoKey.self]
        }
        set {
            self[TagNodeInfoKey.self] = newValue
        }
    }
}

extension View {
    func tagged(_ tag: Int) -> some View {
        self.modifyNodeInfoValue(TagNodeInfoKey.self) {
            $0.insert(tag)
        }
    }
}
