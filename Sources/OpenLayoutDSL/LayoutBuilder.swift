//
//  LayoutBuilder.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayoutCore

public typealias LayoutBuilder = ArrayBuilder<any LayoutItem>

@resultBuilder
public struct ArrayBuilder<Element> {
    public static func buildPartialBlock(first: Element) -> [Element] { [first] }
    public static func buildPartialBlock(first: [Element]) -> [Element] { first }
    public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] { accumulated + [next] }
    public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] { accumulated + next }
    public static func buildBlock() -> [Element] { [] }
    public static func buildEither(first: [Element]) -> [Element] { first }
    public static func buildEither(second: [Element]) -> [Element] { second }
    public static func buildIf(_ element: [Element]?) -> [Element] { element ?? [] }
    public static func buildPartialBlock(first: Never) -> [Element] {}
}
