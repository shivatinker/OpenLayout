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
        print("--- Visualizing layout ---")
        defer { print("--- Layout visualization finished ---") }
        
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
        
        // Apply flipped coordinates transform
        context.translateBy(x: 0, y: totalSize.height)
        context.scaleBy(x: 1, y: -1)
        
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
        let items = result.items
        
        for item in items {
            let adjustedRect = CGRect(
                x: item.rect.origin.x + self.padding,
                y: item.rect.origin.y + self.padding,
                width: item.rect.size.width,
                height: item.rect.size.height
            )
            
            if item.node.leafItem != nil {
                // This is a leaf element (rectangle), draw it with fill and border
                self.drawLeafElement(context: context, rect: adjustedRect, item: item)
            }
            else {
                // This is a non-leaf element (container), draw a thin blue border
                self.drawContainerBorder(context: context, rect: adjustedRect)
            }
        }
        
        return context.makeImage()!
    }
    
    private static func drawLeafElement(context: CGContext, rect: CGRect, item: EvaluatedItem) {
        guard let id = item.attributes.value(for: IDNodeAttributeKey.self) else {
            return
        }
        
        let colorIndex = (id - 1) % self.colors.count
        let color = self.colors[colorIndex]
        
        context.setFillColor(color)
        context.fill(rect)
        
        // Draw rectangle border
        context.setStrokeColor(CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        context.setLineWidth(0.5)
        context.stroke(rect)
        
        // Draw rectangle ID
        let idString = "\(id)"
        let font = CTFontCreateWithName("Helvetica" as CFString, 4, nil)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
        ]
        let attributedString = NSAttributedString(string: idString, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
        // Center the text in the rectangle (accounting for flipped coordinates)
        let textX = rect.midX - bounds.width / 2 - bounds.origin.x
        let textY = rect.midY + bounds.height / 2 + bounds.origin.y
        context.textPosition = CGPoint(x: textX, y: textY)
        CTLineDraw(line, context)
    }
    
    private static func drawContainerBorder(context: CGContext, rect: CGRect) {
        // Draw border exactly on the real border (not centered)
        let borderRect = CGRect(
            x: rect.minX - 0.5, // Adjust for 0.5px line width to be exactly on border
            y: rect.minY - 0.5,
            width: rect.width + 1.0,
            height: rect.height + 1.0
        )
        
        context.setStrokeColor(CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0))
        context.setLineWidth(0.5)
        context.stroke(borderRect)
    }
}
