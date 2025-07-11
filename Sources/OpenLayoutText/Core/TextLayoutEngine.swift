//
//  TextLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import CoreText
import OpenLayout

public struct TextAttributes {
    public var font = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
    public var color = CGColor.black
    public var multilineTextAlignment: Alignment.Horizontal = .left
    
    public init() {}
}

public protocol TextLayoutEngine {
    func sizeThatFits(
        _ proposal: ProposedSize,
        text: String,
        attributes: TextAttributes
    ) -> CGSize
}
