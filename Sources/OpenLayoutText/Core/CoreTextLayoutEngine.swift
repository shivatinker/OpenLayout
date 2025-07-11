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
        
        // Create a path with the constraint size
        let path = CGPath(rect: CGRect(origin: .zero, size: constraintSize), transform: nil)
        
        // Create frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        // Get the lines from the frame
        let lines = CTFrameGetLines(frame) as! [CTLine]
        
        guard !lines.isEmpty else {
            // Empty text case - return size based on font metrics
            let font = attributes.font
            let ascent = CTFontGetAscent(font)
            let descent = CTFontGetDescent(font)
            let leading = CTFontGetLeading(font)
            let lineHeight = ascent + descent + leading
            
            return CGSize(
                width: 0,
                height: lineHeight
            )
        }
        
        // Calculate the total height
        let lineCount = lines.count
        let font = attributes.font
        let ascent = CTFontGetAscent(font)
        let descent = CTFontGetDescent(font)
        let leading = CTFontGetLeading(font)
        let lineHeight = ascent + descent + leading
        
        let totalHeight = CGFloat(lineCount) * lineHeight
        
        // Calculate the maximum width of all lines
        var maxWidth: CGFloat = 0
        for line in lines {
            let lineWidth = CTLineGetTypographicBounds(line, nil, nil, nil)
            maxWidth = max(maxWidth, lineWidth)
        }
        
        // If we have a width constraint, respect it
        if let proposedWidth = proposal.width {
            maxWidth = min(maxWidth, proposedWidth)
        }
        
        // If we have a height constraint, respect it
        let finalHeight = proposal.height.map { min($0, totalHeight) } ?? totalHeight
        
        return CGSize(width: maxWidth, height: finalHeight)
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
