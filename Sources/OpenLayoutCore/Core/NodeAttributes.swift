//
//  NodeAttributes.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

public protocol NodeAttributeKey {
    associatedtype Value: Sendable
    
    static var defaultValue: Value { get }
}

public struct NodeAttributes: Sendable {
    private var storage: [MetatypeWrapper: any Sendable] = [:]
    
    public init() {}
    
    public init<Key: NodeAttributeKey>(key: Key.Type, value: Key.Value) {
        self.set(value, for: key)
    }
    
    mutating func set<Key: NodeAttributeKey>(_ value: Key.Value, for key: Key.Type) {
        self.storage[MetatypeWrapper(key)] = value
    }
    
    public func value<Key: NodeAttributeKey>(for key: Key.Type) -> Key.Value {
        guard let value = self.storage[MetatypeWrapper(key)] else {
            return Key.defaultValue
        }
        
        guard let value = value as? Key.Value else {
            assertionFailure("Incorrect type in node attributes storage")
            return Key.defaultValue
        }
        
        return value
    }
    
    func merge(with other: NodeAttributes) -> NodeAttributes {
        var result = self
        
        for (key, value) in other.storage {
            result.storage[key] = value
        }
        
        return result
    }
    
    private struct MetatypeWrapper: Hashable, Sendable {
        let type: Any.Type
        
        init<Key: NodeAttributeKey>(_ type: Key.Type) {
            self.type = type
        }
        
        static func == (lhs: NodeAttributes.MetatypeWrapper, rhs: NodeAttributes.MetatypeWrapper) -> Bool {
            lhs.type == rhs.type
        }
        
        func hash(into hasher: inout Hasher) {
            ObjectIdentifier(self.type).hash(into: &hasher)
        }
    }
}
