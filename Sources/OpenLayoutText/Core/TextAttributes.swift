//
//  TextAttributes.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

@preconcurrency import CoreText
import OpenLayout

private struct TextAttributesKey: NodeAttributeKey {
    typealias Value = TextAttributes
    
    static let defaultValue = TextAttributes()
}

public struct TextAttributes: Sendable {
    public var font = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
    public var color = CGColor.black
    public var multilineTextAlignment: Alignment.Horizontal = .left
    
    public init() {}
    
    static var current: TextAttributes {
        NodeAttributes.current.value(for: TextAttributesKey.self)
    }
}
