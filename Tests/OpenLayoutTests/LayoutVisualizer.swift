//
//  LayoutVisualizer.swift
//  OpenLayoutTests
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics
import CoreText
import Foundation
import OpenLayout

/// Test-only layout visualizer for Rectangle-based layouts.
enum LayoutVisualizer {
    private static let canvasSize = CGSize(width: 100, height: 100)
    private static let padding: CGFloat = 25
    private static let borderWidth: CGFloat = 2
    private static let scale: CGFloat = 4.0
    
    private static let colors: [CGColor] = [
        CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8), // Red
        CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.8), // Green
        CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.8), // Blue
        CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.8), // Yellow
        CGColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.8), // Magenta
        CGColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.8), // Cyan
        CGColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8), // Orange
        CGColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.8), // Purple
        CGColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.8), // Teal
        CGColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.8), // Olive
    ]
    
    static func visualize(_ layout: some LayoutItem) -> CGImage {
        let totalSize = CGSize(
            width: canvasSize.width + self.padding * 2,
            height: self.canvasSize.height + self.padding * 2
        )
        
        let scaledSize = CGSize(
            width: totalSize.width * self.scale,
            height: totalSize.height * self.scale
        )
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: Int(scaledSize.width),
            height: Int(scaledSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        // Scale the context
        context.scaleBy(x: self.scale, y: self.scale)
        
        // Fill background with white
        context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        context.fill(CGRect(origin: .zero, size: totalSize))
        
        // Draw black border around canvas area
        let canvasRect = CGRect(
            x: padding,
            y: padding,
            width: canvasSize.width,
            height: self.canvasSize.height
        )
        context.setStrokeColor(CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        context.setLineWidth(self.borderWidth)
        context.stroke(canvasRect)
        
        // Evaluate layout
        let engine = LayoutEngine()
        let result = engine.evaluateLayout(
            in: CGRect(origin: .zero, size: self.canvasSize),
            root: layout.makeNode()
        )
        
        // Draw rectangles
        let leafs = result.collectLeafs()
        for leaf in leafs {
            guard let rectangle = leaf.item as? Rectangle else { continue }
            
            let colorIndex = (rectangle.id - 1) % self.colors.count
            let color = self.colors[colorIndex]
            
            context.setFillColor(color)
            
            // Adjust rect to account for padding
            let adjustedRect = CGRect(
                x: leaf.rect.origin.x + self.padding,
                y: leaf.rect.origin.y + self.padding,
                width: leaf.rect.size.width,
                height: leaf.rect.size.height
            )
            
            context.fill(adjustedRect)
            
            // Draw rectangle border
            context.setStrokeColor(CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
            context.setLineWidth(1.0)
            context.stroke(adjustedRect)
            
            // Draw rectangle ID
            let idString = "\(rectangle.id)"
            let font = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
            ]
            
            let attributedString = NSAttributedString(string: idString, attributes: attributes)
            let line = CTLineCreateWithAttributedString(attributedString)
            
            let textRect = CGRect(
                x: adjustedRect.midX - 6,
                y: adjustedRect.midY - 6,
                width: 12,
                height: 12
            )
            
            context.textPosition = CGPoint(x: textRect.minX, y: textRect.minY)
            CTLineDraw(line, context)
        }
        
        return context.makeImage()!
    }
}
