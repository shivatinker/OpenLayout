//
//  TextAttributes.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout
import CoreText

// MARK: - Text Attribute Key

private struct FontNodeAttributeKey: NodeAttributeKey {
    typealias Value = Font
    static let defaultValue: Font = .default
}

extension NodeAttributes {
    public var font: Font {
        self.value(for: FontNodeAttributeKey.self)
    }
}

extension LayoutItem {
    public func font(_ font: Font) -> some LayoutItem {
        self.attribute(FontNodeAttributeKey.self, font)
    }
}
