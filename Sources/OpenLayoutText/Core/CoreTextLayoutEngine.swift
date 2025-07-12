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
        font: Font
    ) -> CGSize {
        let ctFont = CTFontCreateWithName(font.name as CFString, font.size, nil)
        let attributedString = self.createAttributedString(text: text, font: ctFont)
        
        // Create framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        // Always use .infinity for height to avoid cropping text vertically
        let constraintSize = CGSize(
            width: proposal.width ?? CGFloat.infinity,
            height: CGFloat.infinity
        )
        
        var fitRange = CFRange()
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRangeMake(0, attributedString.length),
            nil,
            constraintSize,
            &fitRange
        )
        
        let ascent = CTFontGetAscent(ctFont)
        let descent = CTFontGetDescent(ctFont)
        let leading = CTFontGetLeading(ctFont)
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
        font: CTFont
    ) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: kCTFontAttributeName as String): font,
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}
