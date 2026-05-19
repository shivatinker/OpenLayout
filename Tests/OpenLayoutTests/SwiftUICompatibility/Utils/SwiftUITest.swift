//
//  SwiftUITest.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import AppKit
import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import SwiftUI
import XCTest

@MainActor
final class SwiftUITest {
    private let item: any LayoutItem
    private var size = CGSize(width: 100, height: 100)

    init(_ item: () -> any LayoutItem) {
        self.item = item()
    }

    func setSize(_ size: CGSize) -> SwiftUITest {
        self.size = size
        return self
    }

    func check(file: StaticString = #filePath, line: UInt = #line) {
        let swiftuiBitmap = self.renderSwiftUI()
        let openLayoutBitmap = self.renderOpenLayout()

        let swiftuiImage = self.image(from: swiftuiBitmap)
        let openLayoutImage = self.image(from: openLayoutBitmap)

        XCTContext.runActivity(named: "Snapshot comparison") { activity in
            self.attach(swiftuiImage, name: "SwiftUI.png", to: activity)
            self.attach(openLayoutImage, name: "OpenLayout.png", to: activity)

            if let mismatch = ImageDiffer.compare(swiftuiImage, openLayoutImage, precision: 1.0) {
                self.attach(mismatch.difference, name: "Difference.png", to: activity)
                XCTFail(mismatch.message, file: file, line: line)
            }
        }
    }

    // MARK: - Private

    private func renderSwiftUI() -> NSBitmapImageRep {
        let bitmap = self.makeBitmap()
        let view = SwiftUISupport.swiftUIView(for: self.item).background(.white)
        let host = NSHostingView(rootView: view)
        host.frame = CGRect(origin: .zero, size: self.size)
        host.layout()
        let cgCtx = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
        cgCtx.translateBy(x: 0, y: self.size.height)
        cgCtx.scaleBy(x: 1, y: -1)
        host.layer?.render(in: cgCtx)
        return bitmap
    }

    private func renderOpenLayout() -> NSBitmapImageRep {
        let context = LayoutContext()
        let node = self.item.makeLayoutNode(context: context)
        let fittedSize = node.sizeThatFits(proposal: ProposedSize(self.size))
        let bounds = CGRect(origin: .zero, size: self.size)
        node.place(frame: CGRect(point: bounds.anchorPoint(.center), anchor: .center, size: fittedSize))
        node.doLayout()

        var rects: [RectDrawable] = []
        collectRects(from: node, into: &rects)

        let pixelWidth = Int(self.size.width)
        let pixelHeight = Int(self.size.height)
        let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!

        let cgCtx = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: sRGB,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )!

        // Layout frames use top-left origin; CGContext uses bottom-left — flip Y.
        cgCtx.translateBy(x: 0, y: self.size.height)
        cgCtx.scaleBy(x: 1, y: -1)

        let cyanCG = CGColor(colorSpace: sRGB, components: [0, 0, 1, 1])!
        let whiteCG = CGColor(colorSpace: sRGB, components: [1, 1, 1, 1])!

        cgCtx.setShouldAntialias(false)
        cgCtx.setFillColor(whiteCG)
        cgCtx.fill(bounds)

        for rect in rects {
            cgCtx.setFillColor(cyanCG)
            let drawRect = self.roundRect(rect.frame)
            print(rect.id, rect.frame, drawRect)
            cgCtx.fill(drawRect)
        }

        return NSBitmapImageRep(cgImage: cgCtx.makeImage()!)
    }
    
    private func roundRect(_ rect: CGRect) -> CGRect {
        CGRect(
            x: round(rect.minX),
            y: round(rect.minY),
            width: round(rect.maxX) - round(rect.minX),
            height: round(rect.maxY) - round(rect.minY)
        )
    }

    private func makeBitmap() -> NSBitmapImageRep {
        NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(self.size.width),
            pixelsHigh: Int(self.size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )!
    }

    private func image(from bitmap: NSBitmapImageRep) -> NSImage {
        let image = NSImage(size: self.size)
        image.addRepresentation(bitmap)
        return image
    }

    private func attach(_ image: NSImage, name: String, to activity: XCTActivity) {
        guard let data = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let png = rep.representation(using: .png, properties: [:])
        else { return }
        let attachment = XCTAttachment(data: png, uniformTypeIdentifier: "public.png")
        attachment.name = name
        attachment.lifetime = .deleteOnSuccess
        activity.add(attachment)
    }
}
