//
//  NodeInfo.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

protocol NodeInfoKey {
    associatedtype Value
    
    static func defaultValue() -> Value
}

struct NodeInfo {
    private var storage: [AnyHashable: Any] = [:]

    subscript<K: NodeInfoKey>(_ key: K.Type) -> K.Value {
        get {
            let erasedValue = self.storage[AnyNodeInfoKey(type: key), default: K.defaultValue()]
            
            guard let value = erasedValue as? K.Value else {
                preconditionFailure("Unexpected value type")
            }
            
            return value
        }
        set {
            self.storage[AnyNodeInfoKey(type: key)] = newValue
        }
    }
}

private struct AnyNodeInfoKey<K: NodeInfoKey>: Hashable, Equatable {
    let type: K.Type
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self.type).hash(into: &hasher)
    }
    
    static func == (lhs: AnyNodeInfoKey<K>, rhs: AnyNodeInfoKey<K>) -> Bool {
        ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type)
    }
}
