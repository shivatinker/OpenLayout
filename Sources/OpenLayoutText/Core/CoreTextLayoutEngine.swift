//
//  CoreTextLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import CoreGraphics
import CoreText
import Foundation
import OpenLayout

extension ProposedSize {
    func ceil() -> ProposedSize {
        ProposedSize(
            width: self.width.map(_math.ceil),
            height: self.height.map(_math.ceil)
        )
    }
}

public struct CoreTextLayoutEngine: TextLayoutEngine {
    public init() {}
    
    public func sizeThatFits(
        _ proposal: ProposedSize,
        text: String,
        attributes: TextAttributes
    ) -> CGSize {
        // Create attributed string with the given attributes
        let attributedString = self.createAttributedString(text: text, attributes: attributes)
        
        // Create framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        // Determine the constraint size based on the proposal
        let constraintSize = proposal.replacingUnspecifiedDimensions(
            by: CGSize(
                width: CGFloat.infinity,
                height: CGFloat.infinity
            )
        )
        
        var fitRange = CFRange()
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRangeMake(0, attributedString.length),
            nil,
            constraintSize,
            &fitRange
        )
        
        let font = attributes.font
        let ascent = CTFontGetAscent(font)
        let descent = CTFontGetDescent(font)
        let leading = CTFontGetLeading(font)
        let lineHeight = ascent + descent + leading
        
        // If the text is empty, return font height
        if text.isEmpty {
            return CGSize(width: 0, height: lineHeight)
        }
        
        let width = suggestedSize.width
        let height = suggestedSize.height
        return CGSize(width: width, height: height)
    }
    
    private func createAttributedString(
        text: String,
        attributes: TextAttributes
    ) -> NSAttributedString {
        let font = attributes.font
        let color = attributes.color
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: kCTFontAttributeName as String): font,
            NSAttributedString.Key(rawValue: kCTForegroundColorAttributeName as String): color,
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}
