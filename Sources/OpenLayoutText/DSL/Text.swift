//
//  Text.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import CoreText
import OpenLayout

public struct Text: LayoutLeafItem {
    public let layout: TextLayout
    
    public let text: String
    
    public init(_ text: String) {
        self.text = text
        self.layout = TextLayout(text: text)
    }
}

extension LayoutItem {
    public func font(_ font: CTFont) -> some LayoutItem {
        fatalError()
    }
}
